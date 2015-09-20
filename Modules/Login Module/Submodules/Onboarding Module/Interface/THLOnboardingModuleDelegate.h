//
//  THLOnboardingModuleDelegate.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol THLOnboardingModuleInterface;
@class THLUser;

@protocol THLOnboardingModuleDelegate <NSObject>
- (void)onboardingModule:(id<THLOnboardingModuleInterface>)module didOnboardUser:(THLUser *)user;
@end
