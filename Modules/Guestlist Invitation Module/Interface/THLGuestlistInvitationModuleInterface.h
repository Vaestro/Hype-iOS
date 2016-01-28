//
//  THLGuestlistInvitationModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistInvitationModuleDelegate.h"

@class THLEventEntity;
@class THLGuestEntity;
@protocol THLGuestlistInvitationModuleInterface <NSObject>
@property (nonatomic, weak) id<THLGuestlistInvitationModuleDelegate> moduleDelegate;

- (void)presentGuestlistInvitationInterfaceForEvent:(THLEventEntity *)eventEntity
                                           inController:(UIViewController *)controller;

- (void)presentGuestlistInvitationInterfaceForEvent:(THLEventEntity *)eventEntity
                                        withGuestlistId:(NSString *)guestlistId
                                              andGuests:(NSArray<THLGuestEntity *> *)guestlistInvites
                                           inController:(UIViewController *)controller;

@end
