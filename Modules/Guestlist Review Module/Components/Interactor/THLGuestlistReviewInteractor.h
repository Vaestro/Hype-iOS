//
//  THLGuestlistReviewInteractor.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLGuestlistReviewDataManager;
@class THLGuestlistReviewInteractor;
@class THLViewDataSource;
@class THLGuestEntity;
@class THLGuestlist;
@class THLUser;

@class THLGuestlistEntity;
@class THLGuestlistInviteEntity;
@protocol THLViewDataSourceFactoryInterface;

@protocol THLGuestlistReviewInteractorDelegate <NSObject>
- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInvites:(NSError *)error;
- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInviteResponse:(NSError *)error to:(THLStatus)response;
- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistReviewStatus:(NSError *)error to:(THLStatus)reviewStatus;
- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInviteCheckInStatus:(NSError *)error to:(BOOL)status;
@end

@interface THLGuestlistReviewInteractor : NSObject
@property (nonatomic, weak) id<THLGuestlistReviewInteractorDelegate> delegate;
@property (nonatomic, strong) THLGuestlistEntity *guestlistEntity;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInvite;
@property (nonatomic, strong) NSArray *guests;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLGuestlistReviewDataManager *dataManager;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataManager:(THLGuestlistReviewDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (THLViewDataSource *)generateDataSource;
//- (void)commitChangesToGuestlist;
- (void)checkInForGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite;
- (void)updateGuestlistInvites;
- (void)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withResponse:(THLStatus)response;
- (void)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withCheckInStatus:(BOOL)status;
//- (void)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withCheckInStatus:(BOOL)checkInStatus;
- (void)updateGuestlist:(THLGuestlistEntity *)guestlistEntity withReviewStatus:(THLStatus)reviewStatus;
- (void)unSubscribeChannelsForUser:(THLUser *)userId withGuestlist:(THLGuestlistEntity *)guestlistEntity;
//- (void)checkInGuests;
@end
