//
//  THLGuestlistInvitationWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLGuestlistServiceInterface;

@interface THLGuestlistInvitationWireframe : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestlistServiceInterface> guestlistService;
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService;

- (void)presentInterfaceInViewController:(UIViewController *)controller;
@end
