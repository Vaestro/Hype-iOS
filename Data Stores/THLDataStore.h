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
@class THLYapDatabaseManager;
@class THLDataStoreDomain;

@interface THLDataStore : NSObject

#pragma mark - Dependencies
@property (nonatomic, readonly) THLYapDatabaseManager *databaseManager;
- (instancetype)initForEntity:(Class)entityClass
			  databaseManager:(THLYapDatabaseManager *)databaseManager;

- (instancetype)initForKey:(NSString *)key
              databaseManager:(THLYapDatabaseManager *)databaseManager;

- (NSSet *)entityKeysInDomain:(THLDataStoreDomain *)domain;
- (NSSet *)entitiesInDomain:(THLDataStoreDomain *)domain;
- (void)removeEntitiesInDomain:(THLDataStoreDomain *)domain;
- (NSInteger)countEntitiesInDomain:(THLDataStoreDomain *)domain;

//- (NSString *)collectionKey;
/**
 *  Updates or adds the entities in the datastore.
 */
- (void)updateOrAddEntities:(NSSet *)entities;

/**
 *  Updates the domain with a set of entities. Adds new entities and removes entities that are no
 *	longer present.
 */
- (void)refreshDomain:(THLDataStoreDomain *)domain withEntities:(NSSet *)entities andDeleteEntities:(BOOL)deleteEntities;

//- (void)refreshDomain:(THLDataStoreDomain *)domain withEntities:(NSSet *)entities forCollectionKey:(NSString *)key;

/**
 *  Deletes all entities in the Data Store
 */
- (void)purge;

@end
