//
//  THLEventDetailModuleDelegate.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEventEntity;
@class THLGuestlistEntity;
@class THLGuestlistInviteEntity;

@protocol THLEventDetailModuleInterface;
@protocol THLEventDetailModuleDelegate <NSObject>
- (void)eventDetailModule:(id<THLEventDetailModuleInterface>)module event:(THLEventEntity *)eventEntity withGuestlistId:(NSString *)guestlistId presentGuestlistInvitationInterfaceOnController:(UIViewController *)controller;
- (void)eventDetailModule:(id<THLEventDetailModuleInterface>)module guestlist:(THLGuestlistEntity *)guestlistEntity guestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)controller;
- (void)userNeedsLoginOnViewController:(UIViewController *)viewController;
- (void)dismissEventDetailWireframe;
@end
