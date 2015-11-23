//
//  THLDashboardModuleInterface.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLDashboardModuleDelegate.h"

@protocol THLDashboardModuleInterface <NSObject>
@property (nonatomic, weak) id<THLDashboardModuleDelegate> moduleDelegate;

- (void)presentDashboardInterfaceInViewController:(UIViewController *)viewController;
@end