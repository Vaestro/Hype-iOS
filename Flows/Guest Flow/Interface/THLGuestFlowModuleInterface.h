//
//  THLGuestFlowModuleInterface.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/22/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestFlowModuleDelegate.h"

@protocol THLGuestFlowModuleInterface <NSObject>
@property (nonatomic, weak) id<THLGuestFlowModuleDelegate> moduleDelegate;
- (void)presentGuestFlowModuleInterfaceInWindow:(UIWindow *)window;
@end
