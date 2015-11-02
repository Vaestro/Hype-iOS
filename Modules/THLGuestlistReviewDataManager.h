//
//  THLGuestlistReviewDataManager.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLDataStore;
@class THLEntityMapper;
@class BFTask;
@class THLGuestlistEntity;
@protocol THLGuestlistServiceInterface;

@interface THLGuestlistReviewDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) THLDataStore *dataStore;
@property (nonatomic, readonly) THLEntityMapper *entityMapper;
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
                               dataStore:(THLDataStore *)dataStore;

- (BFTask *)fetchGuestlistInvitesForGuestlist:(NSString *)guestlistId;
@end
