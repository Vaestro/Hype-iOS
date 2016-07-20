//
//  THLRedeemPerkView.h
//  Hype
//
//  Created by Daniel Aksenov on 12/19/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@protocol THLConfirmationViewDelegate <NSObject>
-(void)confirmationViewDidAcceptAction;
-(void)confirmationViewDidDeclineAction;
@end

@interface THLConfirmationView : FXBlurView
@property (nonatomic, weak) id<THLConfirmationViewDelegate> delegate;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *declineButton;
@property (nonatomic, strong) UIButton *dismissButton;

- (void)setInProgressWithMessage:(NSString *)messageText;
- (void)setSuccessWithTitle:(NSString *)titleText Message:(NSString *)messageText;
- (void)dismiss;

#pragma mark Subclassing

@property (nonatomic, assign, readonly) BOOL isBeingShown;
@property (nonatomic, assign, readonly) BOOL isShowing;
@property (nonatomic, assign, readonly) BOOL isBeingDismissed;
@end
