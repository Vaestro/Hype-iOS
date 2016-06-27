//
//  THLLoginViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLOnboardingViewController.h"
#import "THLAppearanceConstants.h"
#import "OnboardingViewController.h"
#import "SVProgressHUD.h"
#import "THLResourceManager.h"
#import "THLActionButton.h"
#import "THLLoginService.h"
#import "THLUser.h"
#import "THLTextEntryViewController.h"
#import <DigitsKit/DigitsKit.h>
#import "THLAppearanceConstants.h"
#import "THLPermissionRequestViewController.h"

//static CGFloat const LOGIN_BUTTON_HEIGHT = 50;
//static CGFloat const PRIVACY_IMAGEVIEW_DIMENSION = 14;

@interface THLOnboardingViewController()
<
THLTextEntryViewDelegate,
THLLoginServiceDelegate,
THLPermissionRequestViewControllerDelegate
>
@property (nonatomic, strong) OnboardingViewController *onboardingViewController;
@property (nonatomic, strong) THLLoginService *loginService;
@property (nonatomic, strong) THLTextEntryViewController *userInfoVerificationViewController;
@property (nonatomic, strong) DGTAppearance *digitsAppearance;

@end

@implementation THLOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.onboardingViewController.view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
}

- (void)handleLogin {
    _loginService = [THLLoginService new];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Touched facebook login button"];
    [[_loginService login] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [self reroute];
        return nil;
    }];
}

- (void)reroute {
    if ([_loginService shouldAddFacebookInformation]) {
        [_loginService saveFacebookUserInformation];
    } else if ([_loginService shouldVerifyPhoneNumber]) {
        [self presentNumberVerificationInterfaceInViewController];
    } else if ([_loginService shouldVerifyEmail]) {
        [self presentUserInfoVerificationView];
    } else if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        [_loginService createMixpanelAlias];
        [self presentPermissionRequestViewController];
    } else {
        [self exitSignupFlow];
    }
}
- (void)loginServiceDidSaveUserFacebookInformation {
    [self reroute];
}

- (void)applicationDidRegisterForRemoteNotifications {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Registered for push notification permission"];
    [self exitSignupFlow];
}

- (void)permissionViewControllerDeclinedPermission {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Declined push notification permission"];
    [self exitSignupFlow];
}

- (void)exitSignupFlow {
//    WEAKSELF();
//    THLUser *currentUser = [THLUser currentUser];
//    [[currentUser saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
        [self.delegate onboardingViewControllerdidFinishSignup];
//        return nil;
//    }];
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

- (void)dealloc {
    DLog(@"Destroyed Onboarding View Controller");
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

- (OnboardingViewController *)onboardingViewController {
    if (!_onboardingViewController) {
        _onboardingViewController = [OnboardingViewController onboardWithBackgroundVideoURL:[THLResourceManager onboardingVideo] contents:[self onboardingContentViewControllers]];
        _onboardingViewController.fontName = @"Raleway-Bold";
        _onboardingViewController.titleFontSize = 24;
        _onboardingViewController.subtitleFontSize = 36;
        _onboardingViewController.bodyFontSize = 18;
        _onboardingViewController.topPadding = 0;
        _onboardingViewController.underIconPadding = SCREEN_HEIGHT*0.067;
        _onboardingViewController.underTitlePadding = 0;
        _onboardingViewController.underSubtitlePadding = SCREEN_HEIGHT*0.2;
        _onboardingViewController.bottomPadding = -10;
        _onboardingViewController.shouldMaskBackground = NO;
        _onboardingViewController.shouldFadeTransitions = YES;
        [self addChildViewController:_onboardingViewController];
        [_onboardingViewController didMoveToParentViewController:self];
        
        [self.view addSubviews:@[_onboardingViewController.view]];
    }

    return _onboardingViewController;
}

- (NSArray *)onboardingContentViewControllers {
    OnboardingContentViewController *firstPage = [OnboardingContentViewController
                                                  initialContentWithTitle:@"WELCOME TO\nTHE HYPE"
                                                  body:@"Discover the most exclusive events happening in NYC"
                                                  backgroundVideo:nil];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"DESIGN THE PERFECT NIGHT"
                                                                                               body:@"Pick the event of your choice and invite your friends to join your party"
                                                                                              image:nil];
    
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"EARN GREAT PERKS"
                                                                                               body:@"Every time you attend an event, you will get credits redeemable for perks like a free limo ride."
                                                                                              image:nil];
    
    OnboardingContentViewController *fourthPage = [OnboardingContentViewController contentWithTitle:@"YOUR PERSONAL CONCIERGE"
                                                                                               body:@"Our team is always available through live chat to answer any questions you have to ensure a smooth night."
                                                                                              image:nil];

    OnboardingContentViewController *fifthPage = [OnboardingContentViewController
                                                   finalContentWithTitle:@"Signup for a great night tonight"
                                                   body:nil
                                                   backgroundImage:[UIImage imageNamed:@"OnboardingLoginBG"]
                                                   buttonText:@"Login with facebook"
                                                   action:^{
                                                       [self handleLogin];
                                                   }
                                                   secondaryButtonText:@"I'll signup later"
                                                   secondaryAction:^{
                                                       [self.delegate onboardingViewControllerdidSkipSignup];
                                                   }];
    
    return @[firstPage,
             secondPage,
             thirdPage,
             fourthPage,
             fifthPage];
}

@end
