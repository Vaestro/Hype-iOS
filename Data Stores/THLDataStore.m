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

//- (void)addObject:(THLEntity *)entity {
//    // Add an object
//    WEAKSELF();
//    STRONGSELF();
//    [self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
//        [transaction setObject:entity forKey:entity.key inCollection:SSELF.collectionKey];
//    }];
//}
//
//- (THLEntity *)readObject:(THLEntity *)entity {
//    WEAKSELF();
//    STRONGSELF();
//    THLEntity *entity = [THLEntity new];
//    [self.roConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
//        [transaction objectForKey:entity.key inCollection:SSELF.collectionKey];
//    }];
//}

- (NSSet *)entityKeysInDomain:(THLDataStoreDomain *)domain {
    WEAKSELF();
    STRONGSELF();
	__block NSMutableSet *keys = [NSMutableSet new];
	[self.roConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
		[transaction enumerateKeysAndObjectsInCollection:SSELF.collectionKey usingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
			if ([domain containsMember:(THLEntity *)object]) {
				[keys addObject:key];
			}
		}];
	}];
	return keys;
}

- (NSSet *)entityKeysNotInDomain:(THLDataStoreDomain *)domain {
    WEAKSELF();
    STRONGSELF();
    __block NSMutableSet *keys = [NSMutableSet new];
    [self.roConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
        [transaction enumerateKeysAndObjectsInCollection:SSELF.collectionKey usingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
            if (![domain containsMember:(THLEntity *)object]) {
                [keys addObject:key];
            }
        }];
    }];
    return keys;
}

- (NSSet *)entitiesInDomain:(THLDataStoreDomain *)domain {
    WEAKSELF();
    STRONGSELF();
	__block NSMutableSet *entities = [NSMutableSet new];
	[self.roConnection readWithBlock:^(YapDatabaseReadTransaction * _Nonnull transaction) {
		[transaction enumerateKeysAndObjectsInCollection:SSELF.collectionKey usingBlock:^(NSString * _Nonnull key, id  _Nonnull object, BOOL * _Nonnull stop) {
			if ([domain containsMember:(THLEntity *)object]) {
				[entities addObject:object];
			}
		}];
	}];
	return entities;
}

- (void)removeEntitiesInDomain:(THLDataStoreDomain *)domain {
    WEAKSELF();
    STRONGSELF();
	__block NSArray *keys = [[self entityKeysInDomain:domain] allObjects];
	[self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
        [transaction removeObjectsForKeys:keys inCollection:SSELF.collectionKey];
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
	__block NSMutableArray *entitiesToRemove = [NSMutableArray arrayWithArray:[[self entityKeysNotInDomain:domain] allObjects]];
    
    WEAKSELF();
    STRONGSELF();
	[self.rwConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
		[transaction enumerateObjectsForKeys:keys inCollection:SSELF.collectionKey unorderedUsingBlock:^(NSUInteger keyIndex, id  _Nonnull object, BOOL * _Nonnull stop) {
			THLEntity *existingEntity = (THLEntity *)object;
			THLEntity *fetchedEntity = [entities member:existingEntity];
			if (!fetchedEntity) {
				//No corresponding entity -> add entity to array to be deleted from database
				[entitiesToRemove addObject:existingEntity.key];
			} else if ([existingEntity shouldUpdateWith:fetchedEntity]) {
                //If corresponding entity was updated more recently -> add entity to array to be updated in database
				[entitiesToUpdate addObject:fetchedEntity];
			}

			[unprocessedEntities removeObject:object];
		}];
        
//        NSLog(@"Entities to update:%ld", entitiesToUpdate.count);
        
        [entitiesToUpdate unionSet:unprocessedEntities];

        if (entitiesToUpdate.count) {
            for (THLEntity *entity in entitiesToUpdate) {
                [transaction setObject:entity forKey:entity.key inCollection:SSELF.collectionKey];
            }
        }

		if (entitiesToRemove.count) {
			[transaction removeObjectsForKeys:entitiesToRemove inCollection:SSELF.collectionKey];
		}
	}];
}

- (void)purge {
    WEAKSELF();
	[self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
		[transaction removeAllObjectsInCollection:WSELF.collectionKey];
	}];
}


@end
