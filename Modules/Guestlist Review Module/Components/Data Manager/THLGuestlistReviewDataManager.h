//
//  THLGuestlistReviewDataManager.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;
@class THLDataStore;
@class THLEntityMapper;
@class THLGuestlistEntity;
@class THLGuestlistInviteEntity;
@protocol THLGuestlistServiceInterface;

@interface THLGuestlistReviewDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;

- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
                               dataStore:(THLDataStore *)dataStore;

- (BFTask *)fetchGuestlistInvitesForGuestlist:(THLGuestlistEntity *)guestlist;
- (BFTask *)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withResponse:(THLStatus)response;
- (BFTask *)updateGuestlist:(THLGuestlistEntity *)guestlist withReviewStatus:(THLStatus)reviewStatus;

@end
