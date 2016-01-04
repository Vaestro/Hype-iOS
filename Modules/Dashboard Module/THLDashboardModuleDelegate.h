//
//  THLDashboardModuleDelegate.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

@protocol THLDashboardModuleInterface;
@class THLEventEntity;
@class THLGuestlistEntity;
@class THLGuestlistInviteEntity;

@protocol THLDashboardModuleDelegate <NSObject>
- (void)dashboardModule:(id<THLDashboardModuleInterface>)module didClickToViewEvent:(THLEventEntity *)event;
- (void)dashboardModule:(id<THLDashboardModuleInterface>)module didClickToViewGuestlist:(THLGuestlistEntity *)guestlistEntity guestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)controller;
- (void)userNeedsLoginOnViewController:(UIViewController *)viewController;

@end