//
//  THLGuestlistInvitationModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistInvitationModuleDelegate.h"

@protocol THLGuestlistInvitationModuleInterface <NSObject>
@property (nonatomic, weak) id<THLGuestlistInvitationModuleDelegate> moduleDelegate;

- (void)presentGuestlistInvitationInterfaceForGuestlist:(NSString *)guestlistId inWindow:(UIWindow *)window;
- (void)presentGuestlistInvitationInterfaceForGuestlist:(NSString *)guestlistId inController:(UIViewController *)controller;
@end
