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

@protocol THLDashboardInteractorDelegate <NSObject>
- (void)interactor:(THLDashboardInteractor *)interactor didGetAcceptedGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite error:(NSError *)error;
@end

@interface THLDashboardInteractor : NSObject
@property (nonatomic, weak) id<THLDashboardInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDashboardDataManager *dataManager;
- (instancetype)initWithDataManager:(THLDashboardDataManager *)dataManager;

- (void)checkForGuestlistInvites;
@end
