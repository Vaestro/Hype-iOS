//
//  THLDataStore.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YapDatabase.h"

@class THLEntity;
@class THLDatabaseManager;

typedef BOOL (^DataStoreEntityDomainTest)(THLEntity *entity);

@interface THLDataStore : NSObject
@property (nonatomic, readonly) THLDatabaseManager *databaseManager;
@property (nonatomic, readonly) NSInteger numEntities;


- (instancetype)initWithDatabaseManager:(THLDatabaseManager *)databaseManager NS_DESIGNATED_INITIALIZER;

+ (NSString *)collectionKey;

- (NSArray *)entityKeysInDomain:(DataStoreEntityDomainTest)domainBlock;
- (NSArray *)entitiesInDomain:(DataStoreEntityDomainTest)domainBlock;
- (void)removeEntitiesInDomain:(DataStoreEntityDomainTest)domainTestBlock;
- (NSInteger)numEntitiesInDomain:(DataStoreEntityDomainTest)domainTestBlock;

/**
 *  Updates the entities in a given domain. If shouldRemove == YES, removes members in the domain 
 *	who do not have a counterpart in the entites array.
 */
- (void)updateWithEntities:(NSArray *)entities
				  inDomain:(DataStoreEntityDomainTest)domainTestBlock
	  removeUnusedEntities:(BOOL)shouldRemove;

/**
 *  Updates the entities in a given domain and removes members in the domain who do not have a
 *	counterpart in the entites array.
 */
- (void)updateWithEntities:(NSArray *)entities
				  inDomain:(DataStoreEntityDomainTest)domainTest;

/**
 *  Deletes all entities in the Data Store
 */
- (void)purge;

@end
