//
//  THLGuestFlowViewController.h
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIkit.h"

@interface THLGuestFlowNavigationController : UINavigationController
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController
                    leftSideViewController:(UIViewController *)leftSideViewController
                        rightSideViewController:(UIViewController *)rightSideViewController;
@end
