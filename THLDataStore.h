//
//  THLDataStore.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLEntity;

typedef BOOL (^DataStoreEntityDomainTest)(THLEntity *entity);

@class YapDatabaseConnection;

@interface THLDataStore : NSObject
@property (nonatomic, readonly) YapDatabaseConnection *rwConnection;
+ (instancetype)sharedDataStore;
- (void)processEntities:(NSArray *)entities inDomain:(DataStoreEntityDomainTest)domainTestBlock;
@end
