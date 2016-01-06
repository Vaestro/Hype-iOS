//
//  THLRedeemPerkView.h
//  Hype
//
//  Created by Daniel Aksenov on 12/19/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface THLConfirmationView : FXBlurView
//@property (nonatomic, strong) RACCommand *dismissCommand;
@property (nonatomic, strong) NSString *confirmationTitle;
@property (nonatomic, strong) NSString *confirmationMessage;
@property (nonatomic, strong) NSString *declineButtonText;
@property (nonatomic, strong) NSString *acceptButtonText;
@property (nonatomic, strong) RACCommand *acceptCommand;
@property (nonatomic, strong) RACCommand *declineCommand;
@property (nonatomic, strong) RACCommand *dismissCommand;

- (void)showResponseFlowWithTitle:(NSString *)title message:(NSString *)message;
- (void)showConfirmationWithTitle:(NSString *)title message:(NSString *)message;
- (void)showInProgressWithMessage:(NSString *)messageText;
- (void)showSuccessWithTitle:(NSString *)titleText Message:(NSString *)messageText;
- (void)dismiss;
- (void)dismissResponseFlow;

#pragma mark Subclassing

@property (nonatomic, assign, readonly) BOOL isBeingShown;
@property (nonatomic, assign, readonly) BOOL isShowing;
@property (nonatomic, assign, readonly) BOOL isBeingDismissed;
@end
