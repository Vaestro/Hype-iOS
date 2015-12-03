//
//  THLHostDashboardModuleInterface.h
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLHostDashboardModuleDelegate.h"

@protocol THLHostDashboardModuleInterface <NSObject>
@property (nonatomic, weak) id<THLHostDashboardModuleDelegate> moduleDelegate;

- (void)presentDashboardInterfaceInViewController:(UIViewController *)viewController;
@end