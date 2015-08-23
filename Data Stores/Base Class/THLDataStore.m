//
//  THLDataStore.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLDataStore.h"
#import "THLDatabaseManager.h"
#import "THLEntity.h"

@interface THLDataStore()
@property (nonatomic, strong) YapDatabaseConnection *rwConnection;
@property (nonatomic, strong) YapDatabaseConnection *roConnection;
@property (nonatomic ,strong) THLDatabaseManager *databaseManager;
@end

@implementation THLDataStore
+ (instancetype)sharedDataStore {
	static THLDataStore *_sharedDataStore = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedDataStore = [self new];
	});

	return _sharedDataStore;
}

+ (NSString *)collectionKey {
	return @"THLDataStoreCollectionKey";
}

- (instancetype)init {
	if (self = [super init]) {
		_databaseManager = [THLDatabaseManager sharedManager];
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


- (NSString *)collectionKey {
	return [NSString stringWithFormat:@"k%@CollectionKey", NSStringFromClass([self class])];
}

- (void)updateWithEntities:(NSArray *)entities
				  inDomain:(DataStoreEntityDomainTest)domainTestBlock
	  removeUnusedEntities:(BOOL)shouldRemove {

	__block NSArray *keysInDomain = [self entityKeysInDomain:domainTestBlock];
	[self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
		__block NSMutableSet *entitiesForUpdates = [NSMutableSet new];
		__block NSMutableSet *keysForRemoval = [NSMutableSet new];

		//Mapping entities array to a dictionary of @{ entity.objectId : entity}
		//for faster access in the following enumeration
		NSDictionary *entityDict = [entities linq_toDictionaryWithKeySelector:^id(THLEntity *entity) {
			return entity.objectId;
		}];
		[transaction enumerateObjectsForKeys:keysInDomain inCollection:self.collectionKey unorderedUsingBlock:^(NSUInteger keyIndex, THLEntity *entity, BOOL *stop) {
			THLEntity *updatedEntity = entityDict[entity.objectId];
			if (!updatedEntity) {
				//No updated entity -> entity was removed from the domain
				[keysForRemoval addObject:keysInDomain[keyIndex]];
			} else if ([entity shouldUpdateWith:updatedEntity]) {
				[entitiesForUpdates addObject:updatedEntity];
			}
		}];

		//Update entities that need updating
		for (THLEntity *entity in entitiesForUpdates) {
			[transaction setObject:entity forKey:entity.objectId inCollection:self.collectionKey];
		}


		//Add new entities to the data store
		NSMutableSet *newEntities = [NSMutableSet setWithArray:entities];
		[newEntities minusSet:entitiesForUpdates];
		for (THLEntity *entity in newEntities) {
			[transaction setObject:entity forKey:entity.objectId inCollection:self.collectionKey];
		}

		//If shouldRemove, remove all old entities from the data store
		if (shouldRemove) {
			[transaction removeObjectsForKeys:keysForRemoval.allObjects inCollection:self.collectionKey];
		}
	}];
}

- (void)updateWithEntities:(NSArray *)entities inDomain:(DataStoreEntityDomainTest)domainTest {
	[self updateWithEntities:entities inDomain:domainTest removeUnusedEntities:YES];
}

- (void)purge {
	[self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
		[transaction removeAllObjectsInCollection:self.collectionKey];
	}];
}

- (NSArray *)entitiesInDomain:(DataStoreEntityDomainTest)domainBlock {
	__block NSArray *keys = [self entityKeysInDomain:domainBlock];
	__block NSMutableArray *entities = [NSMutableArray new];
	[self.roConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
		[transaction enumerateObjectsForKeys:keys inCollection:self.collectionKey unorderedUsingBlock:^(NSUInteger keyIndex, THLEntity *entity, BOOL *stop) {
			[entities addObject:entity];
		}];
	}];
	return entities;
}

- (NSArray *)entityKeysInDomain:(DataStoreEntityDomainTest)domainBlock {
	__block NSMutableArray *keys = [NSMutableArray new];
	[self.roConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
		[transaction enumerateKeysAndObjectsInCollection:self.collectionKey usingBlock:^(NSString *key, id object, BOOL *stop) {
			if (domainBlock && domainBlock((THLEntity *)object)) {
				[keys addObject:key];
			}
		}];
	}];
	return keys;
}

- (void)removeEntitiesInDomain:(DataStoreEntityDomainTest)domainTestBlock {
	NSArray *keysToRemove = [self entityKeysInDomain:domainTestBlock];
	if (keysToRemove.count) {
		[self.rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
			[transaction removeObjectsForKeys:keysToRemove inCollection:self.collectionKey];
		}];
	}
}

- (NSInteger)numEntitiesInDomain:(DataStoreEntityDomainTest)domainTestBlock {
	return [self entityKeysInDomain:domainTestBlock].count;
}

- (NSInteger)numEntities {
	return [self numEntitiesInDomain:^BOOL(THLEntity *entity) {
		return YES;
	}];
}


@end
