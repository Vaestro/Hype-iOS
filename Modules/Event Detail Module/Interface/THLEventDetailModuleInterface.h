//
//  THLEventDetailModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventDetailModuleDelegate.h"
@class THLEventEntity;

@protocol THLEventDetailModuleInterface <NSObject>
@property (nonatomic, weak) id<THLEventDetailModuleDelegate> moduleDelegate;
- (void)presentEventDetailInterfaceForEvent:(THLEventEntity *)eventEntity onViewController:(UIViewController *)viewController;
@end
