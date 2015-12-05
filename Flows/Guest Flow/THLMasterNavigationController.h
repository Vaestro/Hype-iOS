//
//  THLGuestFlowViewController.h
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIkit.h"
#import "SLPagingViewController.h"

@interface THLMasterNavigationController : SLPagingViewController
//- (instancetype)initWithMainViewController:(UIViewController *)mainViewController
//                    leftSideViewController:(UIViewController *)leftSideViewController
//                        rightSideViewController:(UIViewController *)rightSideViewController;

-(instancetype)initWithNavBarItems:(NSArray*)items navBarBackground:(UIColor*)background controllers:(NSArray*)controllers;

-(void)addViewControllers:(UIViewController *) controller needToRefresh:(BOOL) refresh;
@end
