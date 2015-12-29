//
//  THLWaitlistSignupViewController.h
//  Hype
//
//  Created by Phil Meyers IV on 12/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>


@class THLWaitlistSignupViewController;

@protocol THLWaitlistSignupViewDelegate <NSObject>
- (void)signupView:(THLWaitlistSignupViewController *)view userDidSubmitEmail:(NSString *)email;
@end

@interface THLWaitlistSignupViewController : UIViewController
@property (nonatomic, weak) id<THLWaitlistSignupViewDelegate> delegate;

@end
