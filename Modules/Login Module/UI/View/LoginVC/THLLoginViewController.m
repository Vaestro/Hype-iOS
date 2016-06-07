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
#import "THLLoginService.h"
#import "THLUser.h"
#import "THLTextEntryViewController.h"
#import <DigitsKit/DigitsKit.h>
#import "THLAppearanceConstants.h"
#import "THLPermissionRequestViewController.h"

@interface THLLoginViewController()
<
THLTextEntryViewDelegate,
THLPermissionRequestViewControllerDelegate
>
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) THLActionButton *facebookLoginButton;
@property (nonatomic, strong) TTTAttributedLabel *attributedLabel;

@property (nonatomic, strong) THLLoginService *loginService;
@property (nonatomic, strong) THLTextEntryViewController *userInfoVerificationViewController;
@property (nonatomic, strong) DGTAppearance *digitsAppearance;
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

- (void)handleLogin {
    _loginService = [THLLoginService new];
    [[_loginService login] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [self reroute];
        return nil;
    }];
}

- (void)handleDismiss {
//    [self.delegate loginViewControllerdidDismiss];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)reroute {
    if ([_loginService shouldAddFacebookInformation]) {
        [_loginService saveFacebookUserInformation];
    } else if ([_loginService shouldVerifyPhoneNumber]) {
        [self presentNumberVerificationInterfaceInViewController];
    } else if ([_loginService shouldVerifyEmail]) {
        [self presentUserInfoVerificationView];
    } else if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [_loginService createMixpanelProfile];
        [self presentPermissionRequestViewController];
    } else {
        [self saveUserAndExitSignupFlow];
    }
}
- (void)loginServiceDidSaveUserFacebookInformation {
    [self reroute];
}

- (void)applicationDidRegisterForRemoteNotifications {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Registered for push notification permission"];
    [self saveUserAndExitSignupFlow];
}

- (void)permissionViewControllerDeclinedPermission {
    [self saveUserAndExitSignupFlow];
}

- (void)saveUserAndExitSignupFlow {
    WEAKSELF();
    THLUser *currentUser = [THLUser currentUser];
    [[currentUser saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
        [WSELF.delegate loginViewControllerDidFinishSignup];
        return nil;
    }];
}

- (void)presentPermissionRequestViewController {
    THLPermissionRequestViewController *permissionRequestViewController = [THLPermissionRequestViewController new];
    permissionRequestViewController.delegate = self;
    [self.navigationController pushViewController:permissionRequestViewController animated:YES];
}

- (void)presentUserInfoVerificationView {
    [self.navigationController pushViewController:self.userInfoVerificationViewController animated:YES];
}

- (void)emailEntryView:(THLTextEntryViewController *)view userDidSubmitEmail:(NSString *)email {
    THLUser *currentUser = [THLUser currentUser];
    currentUser.email = email;
    WEAKSELF();
    [[currentUser saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
        [WSELF reroute];
        return nil;
    }];}

- (void)presentNumberVerificationInterfaceInViewController {
    WEAKSELF();
    STRONGSELF();
    DGTAuthenticationConfiguration *configuration = [DGTAuthenticationConfiguration new];
    
    configuration.title = NSLocalizedString(@"Number Verification", nil);
    configuration.appearance = self.digitsAppearance;
    [[Digits sharedInstance] authenticateWithViewController:self configuration:configuration completion:^(DGTSession *session, NSError *error) {
        if (!error) {
            [SSELF handleNumberVerificationSuccess:session];
        }
    }];
}

#pragma mark - Logic
- (void)handleNumberVerificationSuccess:(DGTSession *)session {
    THLUser *currentUser = [THLUser currentUser];
    currentUser.phoneNumber = session.phoneNumber;
    WEAKSELF();
    [[currentUser saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
        [WSELF reroute];
        return nil;
    }];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - Accessors
- (THLTextEntryViewController *)userInfoVerificationViewController {
    if (!_userInfoVerificationViewController) {
        _userInfoVerificationViewController  = [[THLTextEntryViewController alloc] initWithNibName:nil bundle:nil];
        _userInfoVerificationViewController.delegate = self;
        _userInfoVerificationViewController.titleText = @"Confirm Info";
        _userInfoVerificationViewController.descriptionText = @"We use your email and phone number to send you confirmations and receipts";
        _userInfoVerificationViewController.buttonText = @"Continue";
        _userInfoVerificationViewController.type = THLTextEntryTypeEmail;
    }
    return _userInfoVerificationViewController;
}

- (DGTAppearance *)digitsAppearance {
    if (!_digitsAppearance) {
        _digitsAppearance = [DGTAppearance new];
        _digitsAppearance.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        _digitsAppearance.accentColor = kTHLNUIAccentColor;
        _digitsAppearance.logoImage = [UIImage imageNamed:@"Hypelist-Icon"];
    }
    return _digitsAppearance;
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
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel_button"] style:UIBarButtonItemStylePlain target:self action:@selector(handleDismiss)];
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
    [loginButton addTarget:self action:@selector(handleLogin) forControlEvents:UIControlEventTouchUpInside];
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
    NSString *labelText = @"By signing up, you agree to our Privacy Policy, Terms & Conditions, and are over the age of 21";
    tttLabel.text = labelText;
    NSRange privacy = [labelText rangeOfString:@"Privacy Policy"];
    NSRange terms = [labelText rangeOfString:@"Terms & Conditions"];
    [tttLabel addLinkToURL:[NSURL URLWithString:@"action://show-privacy"] withRange:privacy];
    [tttLabel addLinkToURL:[NSURL URLWithString:@"action://show-terms"] withRange:terms];
    tttLabel.delegate = self;
    return tttLabel;
}

@end