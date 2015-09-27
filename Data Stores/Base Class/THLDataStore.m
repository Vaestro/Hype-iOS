//
//  THLDataStore.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLDataStore.h"
#import "THLYapDatabaseManager.h"
#import "THLEntity.h"
#import "THLDataStoreDomain.h"
#import "THLEntity+DataStore.h"

@interface THLDataStore()
@property (nonatomic, strong) YapDatabaseConnection *rwConnection;
@property (nonatomic, strong) YapDatabaseConnection *roConnection;
@property (nonatomic, readonly, copy) NSString *collectionKey;
@property (nonatomic) Class entityClass;
@end

@implementation THLDataStore
- (instancetype)initForEntity:(Class)entityClass
			  databaseManager:(THLYapDatabaseManager *)databaseManager {
	if (self = [super init]) {
		_entityClass = entityClass;
		_databaseManager = databaseManager;
	}
	return self;
}

- (YapDatabaseConnection *)rwConnection {
	if (!_rwConnection) {
		_rwConnection = [_databaseManager newDatabaseConnection];
	}
	return _rwConnection;
}

- (YapDatabaseConnection *)roConnection {
	if (!_roConnection) {
		_roConnection = [_databaseManager newDatabaseConnection];
	}
	return _roConnection;
}

- (YapDatabase *)database {
	return _databaseManager.database;
}

- (NSString *)collectionKey {
	return [NSString stringWithFormat:@"k%@DataStoreKey", NSStringFromClass(_entityClass)];
}

- (NSSet *)entityKeysInDomain:(THLDataStoreDomain *)domain {
	__block NSMutableSet *keys = [NSMutableSet new];
	[self.roConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
		[transaction enumerateKeysAndObjectsInCollection:self.collectionKey usingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
			if ([domain containsMember:(THLEntity *)object]) {
				[keys addObject:key];
			}
		}];
	}];
	return keys;
}

- (NSSet *)entitiesInDomain:(THLDataStoreDomain *)domain {
	__block NSMutableSet *entities = [NSMutableSet new];
	[self.roConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
		[transaction enumerateKeysAndObjectsInCollection:self.collectionKey usingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
			if ([domain containsMember:(THLEntity *)object]) {
				[entities addObject:object];
			}
		}];
	}];
	return entities;
}

- (void)removeEntitiesInDomain:(THLDataStoreDomain *)domain {
	__block NSArray *keys = [[self entityKeysInDomain:domain] allObjects];
	[self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
		[transaction removeObjectsForKeys:keys inCollection:self.collectionKey];
	}];
}

- (NSInteger)countEntitiesInDomain:(THLDataStoreDomain *)domain {
	return [self entityKeysInDomain:domain].count;
}

- (void)updateOrAddEntities:(NSSet *)entities {
	THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMembers:[entities allObjects]];
	[self refreshDomain:domain withEntities:entities];
}

- (void)refreshDomain:(THLDataStoreDomain *)domain withEntities:(NSSet *)entities {
	__block NSArray *keys = [[self entityKeysInDomain:domain] allObjects];
	__block NSMutableSet *unprocessedEntities = [entities mutableCopy];
	__block NSMutableSet *entitiesToUpdate = [NSMutableSet new];
	__block NSMutableSet *entitiesToRemove = [NSMutableSet new];

	[self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
		[transaction enumerateObjectsForKeys:keys inCollection:self.collectionKey unorderedUsingBlock:^(NSUInteger keyIndex, id  _Nonnull object, BOOL * _Nonnull stop) {
			THLEntity *oldEntity = (THLEntity *)object;
			THLEntity *newEntity = [entities member:oldEntity];
			if (!newEntity) {
				//No corresponding entity -> remove entity from domain
				[entitiesToRemove addObject:object];
			} else if ([oldEntity shouldUpdateWith:newEntity]) {
				[entitiesToUpdate addObject:object];
			}

			[unprocessedEntities removeObject:object];
		}];

		[entitiesToUpdate unionSet:unprocessedEntities];
		for (THLEntity *entity in entitiesToUpdate) {
			[transaction setObject:entity forKey:entity.key inCollection:self.collectionKey];
		}

		NSArray *keysToRemove = [entitiesToRemove valueForKey:@"key"];
		if (keysToRemove.count) {
			[transaction removeObjectsForKeys:keysToRemove inCollection:self.collectionKey];
		}
	}];
}

- (void)purge {
	[self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
		[transaction removeAllObjectsInCollection:self.collectionKey];
	}];
}


@end
