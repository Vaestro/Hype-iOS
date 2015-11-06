//
//  THLGuestlistInvitationModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistInvitationModuleDelegate.h"

@class THLPromotionEntity;
@class THLGuestEntity;
@protocol THLGuestlistInvitationModuleInterface <NSObject>
@property (nonatomic, weak) id<THLGuestlistInvitationModuleDelegate> moduleDelegate;

- (void)presentGuestlistInvitationInterfaceForPromotion:(THLPromotionEntity *)promotionEntity inController:(UIViewController *)controller;
- (void)presentGuestlistInvitationInterfaceForPromotion:(THLPromotionEntity *)promotionEntity withGuestlistId:(NSString *)guestlistId andGuests:(NSArray<THLGuestEntity *> *)guestlistInvites inController:(UIViewController *)controller;

@end
