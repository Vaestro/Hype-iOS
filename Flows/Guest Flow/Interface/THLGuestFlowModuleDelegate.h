//
//  THLGuestFlowModuleDelegate.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/22/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLGuestFlowModuleInterface;
@protocol THLGuestFlowModuleDelegate <NSObject>
- (void)logInUserOnViewController:(UIViewController *)viewController;
- (void)logOutUser;
@end
