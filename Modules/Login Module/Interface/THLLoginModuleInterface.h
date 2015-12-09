//
//  THLLoginModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLLoginModuleDelegate.h"

@protocol THLLoginModuleInterface <NSObject>
@property (nonatomic, weak) id<THLLoginModuleDelegate> moduleDelegate;

- (void)presentLoginModuleInterfaceWithOnboardingInWindow:(UIWindow *)window;
- (void)presentLoginModuleInterfaceOnViewController:(UIViewController *)viewController;
@end
