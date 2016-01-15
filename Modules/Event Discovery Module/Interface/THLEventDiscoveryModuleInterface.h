//
//  THLEventDiscoveryModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "THLEventDiscoveryModuleDelegate.h"

@protocol THLEventDiscoveryModuleInterface <NSObject>
@property (nonatomic, weak) id<THLEventDiscoveryModuleDelegate> moduleDelegate;

- (void)presentEventDiscoveryInterfaceInNavigationController:(UINavigationController *)navigationController;
@end
