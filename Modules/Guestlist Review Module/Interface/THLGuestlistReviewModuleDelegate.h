//
//  THLGuestlistReviewModuleDelegate.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEventEntity;
@class THLGuestEntity;
@protocol THLGuestlistReviewModuleInterface;
@protocol THLGuestlistReviewModuleDelegate <NSObject>
- (void)guestlistReviewModule:(id<THLGuestlistReviewModuleInterface>)module event:(THLEventEntity *)eventEntity withGuestlistId:(NSString *)guestlistId andGuests:(NSArray<THLGuestEntity *> *)guests presentGuestlistInvitationInterfaceOnController:(UIViewController *)controller;
- (void)dismissGuestlistReviewWireframe;
- (void)guestlistReviewModule:(id<THLGuestlistReviewModuleInterface>)module userDidSelectViewEventEntity:(THLEventEntity *)eventEntity onViewController:(UIViewController *)viewController;
@end