//
//  THLNumberVerificationModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLNumberVerificationModuleDelegate.h"

@protocol THLNumberVerificationModuleInterface <NSObject>
@property (nonatomic, weak) id<THLNumberVerificationModuleDelegate> moduleDelegate;
- (void)presentNumberVerificationInterfaceInViewController:(UIViewController *)viewController;
@end
