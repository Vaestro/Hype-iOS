//
//  THLLoginViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLoginViewController.h"
#import "THLLoginService.h"

#import "THLAppearanceConstants.h"
#import "SVProgressHUD.h"
#import "THLResourceManager.h"
#import "THLActionButton.h"
#import "TTTAttributedLabel.h"
#import "THLInformationViewController.h"
#import "THLUser.h"
#import "THLTextEntryViewController.h"
#import <DigitsKit/DigitsKit.h>
#import "THLAppearanceConstants.h"
#import "THLPermissionRequestViewController.h"
#import "JVFloatLabeledTextField.h"

#import "NSString+EmailAddresses.h"

@interface THLLoginViewController()
<
THLLoginServiceDelegate,
THLTextEntryViewDelegate,
THLPermissionRequestViewControllerDelegate,
TTTAttributedLabelDelegate,
UITextFieldDelegate
>
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) THLActionButton *facebookLoginButton;
@property (nonatomic, strong) THLActionButton *emailLoginButton;

@property (nonatomic, strong) TTTAttributedLabel *attributedLabel;

@property (nonatomic, strong) THLLoginService *loginService;
@property (nonatomic, strong) THLTextEntryViewController *userInfoVerificationViewController;
@property (nonatomic, strong) DGTAppearance *digitsAppearance;

@property (nonatomic, strong) JVFloatLabeledTextField *emailField;
@property (nonatomic, strong) JVFloatLabeledTextField *passwordField;

@end

@implementation THLLoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = self.dismissButton;
    
    self.loginService = [THLLoginService new];
    self.loginService.delegate = self;
    
    WEAKSELF();
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(75);
        make.centerX.equalTo(0);
        make.size.mas_equalTo(CGSizeMake1(50.0f));
    }];
    
    [self.bodyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo([WSELF logoImageView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.width.equalTo(SCREEN_WIDTH*0.67);
    }];
    
    [self.facebookLoginButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF emailField].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.equalTo(0);
        make.height.equalTo(50);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.emailField makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF passwordField].mas_top).insets(kTHLEdgeInsetsHigh());
        make.centerX.equalTo(0);
        make.height.equalTo(50);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.passwordField makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF emailLoginButton].mas_top).insets(kTHLEdgeInsetsHigh());
        make.centerX.equalTo(0);
        make.height.equalTo(50);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.emailLoginButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-35);
        make.centerX.equalTo(0);
        make.height.equalTo(50);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
}

- (void)handleFacebookLogin {
    [_loginService loginWithFacebook];
}

- (void)handleEmailLogin {
    [_loginService loginWithEmail:_emailField.text andPassword:_passwordField.text];
}


- (void)handleDismiss {
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (void)applicationDidRegisterForRemoteNotifications {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Registered for push notification permission"];
    [self.delegate loginViewControllerDidFinishSignup];
}

- (void)permissionViewControllerDeclinedPermission {
    [self.delegate loginViewControllerDidFinishSignup];
}

#pragma mark - THLLoginServiceDelegate
- (void)loginServiceDidLoginUser {
    [self.delegate loginViewControllerDidFinishSignup];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_emailField.text isValidEmailAddress] && _passwordField.text.length > 6) {
        _emailLoginButton.enabled = true;
        _emailLoginButton.backgroundColor = kTHLNUIAccentColor;
    } else {
        _emailLoginButton.enabled = false;
        _emailLoginButton.backgroundColor = [UIColor clearColor];
    }
}


#pragma mark - Accessors
- (JVFloatLabeledTextField *)emailField {
    if (!_emailField) {
        _emailField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
        [_emailField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: kTHLNUIGrayFontColor}]];
        _emailField.backgroundColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.10];
        _emailField.delegate = self;
        _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.view addSubview:_emailField];
    }
 
    return _emailField;
}

- (JVFloatLabeledTextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [[JVFloatLabeledTextField alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
        [_passwordField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: kTHLNUIGrayFontColor}]];
        _passwordField.backgroundColor =[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.10];
        _passwordField.delegate = self;
        _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordField.autocorrectionType = UITextAutocorrectionTypeNo;

        [self.view addSubview:_passwordField];

    }
    return _passwordField;
}

- (UILabel *)bodyLabel {
    if (!_bodyLabel) {
        _bodyLabel = [UILabel new];
        _bodyLabel.text = @"Welcome back. It's good seeing you again";
        _bodyLabel.textColor = kTHLNUIGrayFontColor;
        _bodyLabel.font = [UIFont fontWithName:@"Raleway-Light" size:18];
        _bodyLabel.numberOfLines = 0;
        _bodyLabel.adjustsFontSizeToFitWidth = YES;
        _bodyLabel.minimumScaleFactor = 0.5;
        _bodyLabel.textAlignment = NSTextAlignmentCenter;
        [_bodyLabel sizeToFit];
        [self.view addSubview:_bodyLabel];
    }
    return _bodyLabel;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
        _logoImageView.image = [UIImage imageNamed:@"Hypelist-Icon"];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        _logoImageView.clipsToBounds = YES;
        [self.view addSubview:_logoImageView];
    }

    return _logoImageView;
}

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backgroundView.clipsToBounds = YES;
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        [_backgroundView setImage:[UIImage imageNamed:@"OnboardingLoginBG"]];
        [self.view addSubview:_backgroundView];
        [self.view sendSubviewToBack:_backgroundView];
    }

    return _backgroundView;
}

- (UIBarButtonItem *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_button"] style:UIBarButtonItemStylePlain target:self action:@selector(handleDismiss)];
        [_dismissButton setTintColor:kTHLNUIGrayFontColor];
        [_dismissButton setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                            forState:UIControlStateNormal];
    }
    
    return _dismissButton;
}

- (THLActionButton *)facebookLoginButton {
    if (!_facebookLoginButton) {
        _facebookLoginButton = [[THLActionButton alloc] initWithFacebookStyle];
        [_facebookLoginButton setTitle:@"Continue with Facebook"];
        [_facebookLoginButton addTarget:self action:@selector(handleFacebookLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_facebookLoginButton];
    }

    return _facebookLoginButton;
}

- (THLActionButton *)emailLoginButton {
    if (!_emailLoginButton) {
        _emailLoginButton = [[THLActionButton alloc] initWithInverseStyle];
        [_emailLoginButton setTitle:@"Login"];
        _emailLoginButton.enabled = false;
        [_emailLoginButton addTarget:self action:@selector(handleEmailLogin) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:_emailLoginButton];

    }
    return _emailLoginButton;
}

@end