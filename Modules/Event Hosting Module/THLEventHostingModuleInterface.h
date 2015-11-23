//
//  THLEventHostingModuleInterface.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "THLEventHostingModuleDelegate.h"
@class THLGuestlistEntity;
@class THLEventEntity;

@protocol THLEventHostingModuleInterface <NSObject>
@property (nonatomic, weak) id<THLEventHostingModuleDelegate> moduleDelegate;
- (void)presentEventHostingInterfaceForEvent:(THLEventEntity *)eventEntity inWindow:(UIWindow *)_window;
@end

