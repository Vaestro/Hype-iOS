//
//  THLGuestlistReviewModuleDelegate.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLPromotionEntity;
@class THLGuestEntity;
@protocol THLGuestlistReviewModuleInterface;
@protocol THLGuestlistReviewModuleDelegate <NSObject>
- (void)guestlistReviewModule:(id<THLGuestlistReviewModuleInterface>)module promotion:(THLPromotionEntity *)promotionEntity withGuestlistId:(NSString *)guestlistId andGuests:(NSArray<THLGuestEntity *> *)guests presentGuestlistInvitationInterfaceOnController:(UIViewController *)controller;
- (void)dismissGuestlistReviewWireframe;

@end