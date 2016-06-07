//
//  THLLoginViewController.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLOnboardingViewInterface.h"


@protocol THLOnboardingViewControllerDelegate <NSObject>

-(void)onboardingViewControllerdidFinishSignup;
-(void)onboardingViewControllerdidSkipSignup;

@end


@interface THLOnboardingViewController : UIViewController<THLOnboardingViewInterface>
@property (nonatomic, weak) id<THLOnboardingViewControllerDelegate> delegate;

- (void)applicationDidRegisterForRemoteNotifications;
@end
