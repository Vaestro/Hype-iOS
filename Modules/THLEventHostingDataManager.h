//
//  THLEventHostingDataManager.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLDataStore;
@class THLEntityMapper;
@class BFTask;
@protocol THLGuestlistServiceInterface;

@interface THLEventHostingDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                     entityMapper:(THLEntityMapper *)entityMapper;

- (BFTask *)fetchGuestlistsForPromotionAtEvent:(NSString *)eventId;
@end