//
//  THLDashboardInteractor.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLDashboardDataManager;
@class THLDashboardInteractor;
@class THLGuestlistInviteEntity;
@class THLViewDataSource;
@protocol THLViewDataSourceFactoryInterface;

@protocol THLDashboardInteractorDelegate <NSObject>
- (void)interactor:(THLDashboardInteractor *)interactor didUpdateGuestlistInvites:(BFTask *)task;
@end

@interface THLDashboardInteractor : NSObject
@property (nonatomic, weak) id<THLDashboardInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDashboardDataManager *dataManager;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;

- (instancetype)initWithDataManager:(THLDashboardDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (void)updateGuestlistInvites;
- (THLViewDataSource *)getDataSource;
- (void)updateGuestlistInviteToOpened:(THLGuestlistInviteEntity *)guestlistInvite;
@end
