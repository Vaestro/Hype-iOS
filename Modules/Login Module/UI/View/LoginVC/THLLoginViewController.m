//
//  THLLoginViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLoginViewController.h"
#import "THLAppearanceConstants.h"
#import "SVProgressHUD.h"
#import "THLResourceManager.h"
#import "THLActionButton.h"
#import "TTTAttributedLabel.h"
#import "THLInformationViewController.h"

@interface THLLoginViewController()
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) THLActionButton *facebookLoginButton;
@property (nonatomic, strong) TTTAttributedLabel *attributedLabel;

@end

@implementation THLLoginViewController
@synthesize showActivityIndicator;
@synthesize dismissCommand;
@synthesize loginCommand;
@synthesize loginText;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)constructView {
    _backgroundView = [self newBackgroundView];
    _logoImageView = [self newLogoImageView];
    _dismissButton = [self newDismissButton];
    _bodyLabel = [self newBodyLabel];
    _facebookLoginButton = [self newFacebookLoginButton];
    _attributedLabel = [self newAttributedLabel];
}

- (void)layoutView {
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = _dismissButton;
        
    [self.view addSubviews:@[_backgroundView, _logoImageView, _bodyLabel, _facebookLoginButton, _attributedLabel]];
    WEAKSELF();
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(SV([WSELF logoImageView]).centerX);
        make.bottom.equalTo(SV([WSELF logoImageView]).centerY).insets(kTHLEdgeInsetsSuperHigh());
        make.size.mas_equalTo(CGSizeMake1(75.0f));
    }];
    
    [_bodyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(SV([WSELF logoImageView]).centerX);
        make.top.equalTo(SV([WSELF logoImageView]).centerY).insets(kTHLEdgeInsetsSuperHigh());
        make.width.equalTo(SCREEN_WIDTH*0.67);
    }];
    
    [_backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(UIEdgeInsetsZero);
    }];
    
    [_facebookLoginButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF attributedLabel].mas_top).insets(kTHLEdgeInsetsInsanelyHigh());
        make.centerX.equalTo(SV([WSELF facebookLoginButton]).centerX);
        make.height.equalTo(50);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_attributedLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-35);
        make.centerX.equalTo(SV([WSELF attributedLabel]).centerX);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.view sendSubviewToBack:_backgroundView];
}

- (void)bindView {
    RAC(self.dismissButton, rac_command) = RACObserve(self, dismissCommand);

    RAC(self.facebookLoginButton, rac_command) = RACObserve(self, loginCommand);
    RAC(self.facebookLoginButton, titleLabel.text) = RACObserve(self, loginText);
    [RACObserve(self, showActivityIndicator) subscribeNext:^(NSNumber *activityStatus) {
        if (activityStatus == [NSNumber numberWithInt:0]) {
            [SVProgressHUD dismiss];
        }
        else if (activityStatus == [NSNumber numberWithInt:1]) {
            [SVProgressHUD show];
        }
        else if (activityStatus == [NSNumber numberWithInt:3]) {
            [SVProgressHUD showErrorWithStatus:@"Error Logging In, Please Try Again."];
        }
    }];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if ([[url scheme] hasPrefix:@"action"]) {
        if ([[url host] hasPrefix:@"show-privacy"]) {
            THLInformationViewController *infoVC = [THLInformationViewController new];
            UINavigationController *navVC= [[UINavigationController alloc] initWithRootViewController:infoVC];
            [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
            infoVC.displayText = [THLResourceManager privacyPolicyText];
            infoVC.title = @"Privacy Policy";
        } else if ([[url host] hasPrefix:@"show-terms"]) {
            THLInformationViewController *infoVC = [THLInformationViewController new];
            UINavigationController *navVC= [[UINavigationController alloc] initWithRootViewController:infoVC];
            [self.view.window.rootViewController presentViewController:navVC animated:YES completion:nil];
            infoVC.displayText = [THLResourceManager termsOfUseText];
            infoVC.title = @"Terms Of Use";
        }
    } else {
        /* deal with http links here */
    }
}

#pragma mark - Constructors
- (UILabel *)newBodyLabel {
    UILabel *bodyLabel = [UILabel new];
    bodyLabel.text = @"Signup for a great night tonight";
    bodyLabel.textColor = kTHLNUIGrayFontColor;
    bodyLabel.font = [UIFont fontWithName:@"Raleway-Light" size:24];
    bodyLabel.numberOfLines = 0;
    bodyLabel.adjustsFontSizeToFitWidth = YES;
    bodyLabel.minimumScaleFactor = 0.5;
    bodyLabel.textAlignment = NSTextAlignmentCenter;
    [bodyLabel sizeToFit];
    return bodyLabel;
}

- (UIImageView *)newLogoImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"Hypelist-Icon"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (UIImageView *)newBackgroundView {
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImage:[UIImage imageNamed:@"OnboardingLoginBG"]];
    return imageView;
}

- (UIBarButtonItem *)newDismissButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_button"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [item setTintColor:kTHLNUIGrayFontColor];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

- (THLActionButton *)newFacebookLoginButton {
    THLActionButton *loginButton = [[THLActionButton alloc] initWithInverseStyle];
    [loginButton setTitle:@"Login with Facebook"];
    return loginButton;
}

- (TTTAttributedLabel *)newAttributedLabel {
    TTTAttributedLabel *tttLabel = [TTTAttributedLabel new];
    tttLabel.textColor = kTHLNUIGrayFontColor;
    tttLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    tttLabel.numberOfLines = 0;
    tttLabel.adjustsFontSizeToFitWidth = YES;
    tttLabel.minimumScaleFactor = 0.5;
    tttLabel.linkAttributes = @{NSForegroundColorAttributeName: kTHLNUIGrayFontColor,
                                NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    tttLabel.activeLinkAttributes = @{NSForegroundColorAttributeName: kTHLNUIPrimaryFontColor,
                                      NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    tttLabel.textAlignment = NSTextAlignmentCenter;
    NSString *labelText = @"By signing up, you agree to our Privacy Policy and Terms & Conditions";
    tttLabel.text = labelText;
    NSRange privacy = [labelText rangeOfString:@"Privacy Policy"];
    NSRange terms = [labelText rangeOfString:@"Terms & Conditions"];
    [tttLabel addLinkToURL:[NSURL URLWithString:@"action://show-privacy"] withRange:privacy];
    [tttLabel addLinkToURL:[NSURL URLWithString:@"action://show-terms"] withRange:terms];
    tttLabel.delegate = self;
    return tttLabel;
}

@end