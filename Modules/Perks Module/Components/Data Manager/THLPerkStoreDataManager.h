//
//  THLPerkStoreDataManager.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLDataStore;
@class THLEntityMapper;
@class BFTask;
@protocol THLPerkStoreItemServiceInterface;


@interface THLPerkStoreDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLPerkStoreItemServiceInterface> perkService;
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     entityMapper:(THLEntityMapper *)entityMapper
                      perkService:(id<THLPerkStoreItemServiceInterface>)perkService;

- (BFTask *)fetchAllPerkStoreItems;
- (BFTask *)fetchCreditsForUser;
@end
