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
@protocol THLGuestlistServiceInterface;

@interface THLGuestlistReviewDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly) THLDataStore *dataStore;
@property (nonatomic, readonly) THLEntityMapper *entityMapper;

- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
                               dataStore:(THLDataStore *)dataStore;

- (BFTask *)fetchGuestlistInvitesForGuestlist:(NSString *)guestlistId;
@end
