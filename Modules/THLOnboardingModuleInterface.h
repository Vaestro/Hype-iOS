//
//  THLOnboardingModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLOnboardingModuleDelegate.h"

@class THLUser;
@protocol THLOnboardingModuleInterface <NSObject>
@property (nonatomic, weak) id<THLOnboardingModuleDelegate> moduleDelegate;

- (void)presentInterfaceForOnboardingUser:(THLUser *)user inWindow:(UIWindow *)window;
@end
