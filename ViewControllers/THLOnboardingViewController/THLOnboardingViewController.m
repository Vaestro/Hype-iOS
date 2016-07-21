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
#import "OnboardingContentViewController.h"

#import "SVProgressHUD.h"
#import "THLResourceManager.h"
#import "THLActionButton.h"
#import "THLLoginService.h"
#import "THLUser.h"
#import "THLTextEntryViewController.h"
#import <DigitsKit/DigitsKit.h>
#import "THLAppearanceConstants.h"
#import "THLPermissionRequestViewController.h"
#import "THLSignUpViewController.h"

//static CGFloat const LOGIN_BUTTON_HEIGHT = 50;
//static CGFloat const PRIVACY_IMAGEVIEW_DIMENSION = 14;

@interface THLOnboardingViewController()
<
THLLoginServiceDelegate,
OnboardingContentViewControllerDelegate,
THLTextEntryViewDelegate,
THLLoginServiceDelegate,
THLPermissionRequestViewControllerDelegate,
THLSignUpViewControllerDelegate
>
@property (nonatomic, strong) OnboardingViewController *onboardingViewController;
@property (nonatomic, strong) THLLoginService *loginService;
@property (nonatomic, strong) THLSignUpViewController *signUpViewController;

@end

@implementation THLOnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    self.loginService = [THLLoginService new];
    self.loginService.delegate = self;
    self.loginService.navigationController = self.navigationController;

    [self.onboardingViewController.view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
}

- (void)handleFacebookSignUp {
    [_loginService signUpWithFacebook];
}

- (void)showEmailSignUp {
    [self.navigationController pushViewController:self.signUpViewController animated:true];
}

- (void)applicationDidRegisterForRemoteNotifications {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Registered for push notification permission"];
    [self exitSignupFlow];
}

- (void)exitSignupFlow {
    [self.delegate onboardingViewControllerdidFinishSignup];
}

- (void)onboardingViewControllerWantsToShowLoginView {
    [self.delegate usersWantsToLogin];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)signUpViewControllerDidFinishSignup {
    [self exitSignupFlow];
}

#pragma mark - Accessors
- (THLSignUpViewController *)signUpViewController {
    if (!_signUpViewController) {
        _signUpViewController  = [[THLSignUpViewController alloc] initWithNibName:nil bundle:nil];
        _signUpViewController.delegate = self;
    }
    return _signUpViewController;
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
                                                       [self handleFacebookSignUp];
                                                   }
                                                   secondaryButtonText:@"I'll signup later"
                                                   secondaryAction:^{
                                                       [self showEmailSignUp];
                                                   }];
    firstPage.loginDelegate = self;
    secondPage.loginDelegate = self;
    thirdPage.loginDelegate = self;
    fourthPage.loginDelegate = self;
    fifthPage.loginDelegate = self;
    
    return @[firstPage,
             secondPage,
             fourthPage,
             fifthPage];
}

@end
