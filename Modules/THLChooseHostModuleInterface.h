//
//  THLChooseHostModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLChooseHostModuleDelegate.h"

@class THLEvent;
@protocol THLChooseHostModuleInterface <NSObject>
@property (nonatomic, weak) id<THLChooseHostModuleDelegate> moduleDelegate;

- (void)presentChooseHostInterfaceForEvent:(THLEvent *)event inWindow:(UIWindow *)window;
@end
