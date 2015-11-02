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
@class THLGuestlistEntity;
@class THLGuestlistInviteEntity;
@protocol THLViewDataSourceFactoryInterface;

@protocol THLGuestlistReviewInteractorDelegate <NSObject>
- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInvites:(NSError *)error;
@end

@interface THLGuestlistReviewInteractor : NSObject
@property (nonatomic, weak) id<THLGuestlistReviewInteractorDelegate> delegate;
@property (nonatomic, strong) THLGuestlistEntity *guestlistEntity;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLGuestlistReviewDataManager *dataManager;
@property (nonatomic, readonly) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataManager:(THLGuestlistReviewDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (THLViewDataSource *)generateDataSource;
- (void)acceptGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity;
- (void)declineGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity;
- (void)confirmGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity;
- (void)acceptGuestlist:(THLGuestlistEntity *)guestlistEntity;
- (void)declineGuestlist:(THLGuestlistEntity *)guestlistEntity;

- (void)commitChangesToGuestlist;
- (void)updateGuestlistInvites;

@end
