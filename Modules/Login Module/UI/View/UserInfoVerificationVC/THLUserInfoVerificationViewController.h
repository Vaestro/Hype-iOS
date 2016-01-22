//
//  THLInfoVerificationViewController.h
//  Hype
//
//  Created by Edgar Li on 1/18/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//
#import <UIKit/UIKit.h>


@class THLUserInfoVerificationViewController;

@protocol THLUserInfoVerificationViewDelegate <NSObject>
- (void)userInfoVerificationView:(THLUserInfoVerificationViewController *)view userDidConfirmEmail:(NSString *)email;
@end

@interface THLUserInfoVerificationViewController : UIViewController
@property (nonatomic, weak) id<THLUserInfoVerificationViewDelegate> delegate;

@end