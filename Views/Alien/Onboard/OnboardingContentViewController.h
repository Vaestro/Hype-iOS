//
//  OnboardingContentViewController.h
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OnboardingViewController;

typedef void (^action_callback)(OnboardingViewController *onboardController);

@interface OnboardingContentViewController : UIViewController {
    NSString *_titleText;
    NSString *_subtitleText;
    NSString *_body;
    UIImage *_image;
    NSString *_buttonText;
    NSString *_secondaryButtonText;

    UIImageView *_imageView;
    UILabel *_mainTextLabel;
    UILabel *_subTextLabel;
    UILabel *_bodyTextLabel;
    UIButton *_actionButton;
    UIButton *_secondaryButton;

}

@property (nonatomic) OnboardingViewController *delegate;

@property (nonatomic) BOOL movesToNextViewController;

@property (nonatomic) CGFloat iconHeight;
@property (nonatomic) CGFloat iconWidth;

@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) UIColor *subtitleTextColor;
@property (nonatomic, strong) UIColor *bodyTextColor;
@property (nonatomic, strong) UIColor *buttonTextColor;
@property (nonatomic, strong) UIColor *secondaryButtonTextColor;

@property (nonatomic, strong) NSString *titleFontName;
@property (nonatomic) CGFloat titleFontSize;

@property (nonatomic, strong) NSString *subtitleFontName;
@property (nonatomic) CGFloat subtitleFontSize;

@property (nonatomic, strong) NSString *bodyFontName;
@property (nonatomic) CGFloat bodyFontSize;

@property (nonatomic, strong) NSString *buttonFontName;
@property (nonatomic) CGFloat buttonFontSize;

@property (nonatomic) CGFloat topPadding;
@property (nonatomic) CGFloat underIconPadding;
@property (nonatomic) CGFloat underTitlePadding;
@property (nonatomic) CGFloat underSubtitlePadding;
@property (nonatomic) CGFloat bottomPadding;
@property (nonatomic) CGFloat underPageControlPadding;

@property (nonatomic, copy) action_callback buttonActionHandler;
@property (nonatomic, copy) action_callback secondaryButtonActionHandler;

@property (nonatomic, copy) dispatch_block_t viewWillAppearBlock;
@property (nonatomic, copy) dispatch_block_t viewDidAppearBlock;
@property (nonatomic, copy) dispatch_block_t viewWillDisappearBlock;
@property (nonatomic, copy) dispatch_block_t viewDidDisappearBlock;

+ (instancetype)contentWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action secondaryButtonText:(NSString *)secondaryButtonText secondaryAction:(dispatch_block_t)secondaryAction;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action secondaryButtonText:(NSString *)secondaryButtonText secondaryAction:(dispatch_block_t)secondaryAction;

+ (instancetype)contentWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock secondaryButtonText:(NSString *)secondaryButtonText secondaryActionBlock:(action_callback)secondaryActionBlock;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle body:(NSString *)body image:(UIImage *)image buttonText:(NSString *)buttonText actionBlock:(action_callback)actionBlock secondaryButtonText:(NSString *)secondaryButtonText secondaryActionBlock:(action_callback)secondaryActionBlock;

- (void)updateAlphas:(CGFloat)newAlpha;

@end