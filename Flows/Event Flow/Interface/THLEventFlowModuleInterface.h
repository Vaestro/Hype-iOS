//
//  THLEventFlowModuleInterface.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/22/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventFlowModuleDelegate.h"

@protocol THLEventFlowModuleInterface <NSObject>
@property (nonatomic, weak) id<THLEventFlowModuleDelegate> moduleDelegate;

- (void)presentEventFlowModuleInterfaceInWindow:(UIWindow *)window;
@end
