//
//  THLPerkDataManager.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLDataStore;
@class THLEntityMapper;
@class BFTask;
@protocol THLPerkItemStoreServiceInterface;


@interface THLPerkDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLPerkItemStoreServiceInterface> perkService;
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     entityMapper:(THLEntityMapper *)entityMapper
                      perkService:(id<THLPerkItemStoreServiceInterface>)perkService;

- (BFTask *)fetchAllPerkStoreItems;
- (BFTask *)fetchCreditsForUser;
@end
