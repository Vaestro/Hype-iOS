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
@protocol THLGuestlistInvitationModuleInterface <NSObject>
@property (nonatomic, weak) id<THLGuestlistInvitationModuleDelegate> moduleDelegate;

- (void)presentGuestlistInvitationInterfaceForPromotion:(THLPromotionEntity *)promotionEntity forGuestlist:(NSString *)guestlistId inWindow:(UIWindow *)window;
@end
