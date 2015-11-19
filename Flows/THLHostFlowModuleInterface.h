//
//  THLHostFlowModuleInterface.h
//  TheHypelist
//
//  Created by Edgar Li on 11/18/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLHostFlowModuleDelegate.h"

@protocol THLHostFlowModuleInterface <NSObject>
@property (nonatomic, weak) id<THLHostFlowModuleDelegate> moduleDelegate;
- (void)presentHostFlowModuleInterfaceInWindow:(UIWindow *)window;
@end
