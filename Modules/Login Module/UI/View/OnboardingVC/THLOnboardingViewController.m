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
#import "THLActionBarButton.h"

//static CGFloat const LOGIN_BUTTON_HEIGHT = 50;
//static CGFloat const PRIVACY_IMAGEVIEW_DIMENSION = 14;

@interface THLOnboardingViewController()
@property (nonatomic, strong) UIButton *skipButton;
@property (nonatomic, strong) UIButton *facebookLoginButton;
@property (nonatomic, strong) OnboardingViewController *onboardingVC;
@end

@implementation THLOnboardingViewController
@synthesize showActivityIndicator;
@synthesize skipCommand;
@synthesize loginCommand;
@synthesize loginText;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)constructView {
    _onboardingVC = [self newOnboardingViewController];
    _skipButton = [self newSkipButton];
    _facebookLoginButton = [self newFacebookLoginButton];
}

- (void)layoutView {
    self.view.backgroundColor = [UIColor blackColor];
    [self addChildViewController:_onboardingVC];
    [_onboardingVC didMoveToParentViewController:self];
    
    [self.view addSubviews:@[_onboardingVC.view, _facebookLoginButton, _skipButton]];
    
    WEAKSELF();
    [_onboardingVC.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(UIEdgeInsetsZero);
    }];
    
    [_facebookLoginButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsHigh());
        make.height.equalTo(60);
        make.bottom.equalTo([WSELF skipButton].mas_top).insets(UIEdgeInsetsZero);
    }];
    
    [_skipButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(UIEdgeInsetsZero);
        make.bottom.insets(UIEdgeInsetsMake1(25));
    }];
}

- (void)bindView {
    RAC(self.skipButton, rac_command) = RACObserve(self, skipCommand);
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

#pragma mark - Constructors

- (UIButton *)newSkipButton {
    UIButton *button = THLNUIButton(kTHLNUIUndef);
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.alpha = 0.75;
    [button setTitle:@"Or skip for now" forState:UIControlStateNormal];
    return button;
}

- (UIButton *)newFacebookLoginButton {
    UIButton *loginButton = [UIButton new];
    loginButton.backgroundColor = kTHLNUIBlueColor;
    [loginButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    [loginButton setTitleColor:kTHLNUIPrimaryFontColor forState:UIControlStateNormal];
    return loginButton;
}

- (OnboardingViewController *)newOnboardingViewController {
    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundVideoURL:[THLResourceManager onboardingVideo] contents:[self onboardingContentViewControllers]];
    onboardingVC.fontName = @"Raleway-Bold";
    onboardingVC.titleFontSize = 24;
    onboardingVC.subtitleFontSize = 40;
    onboardingVC.bodyFontSize = 24;
    onboardingVC.topPadding = 0;
    onboardingVC.underIconPadding = 67;
    onboardingVC.underTitlePadding = 0;
    onboardingVC.underSubtitlePadding = SCREEN_HEIGHT/4;
    onboardingVC.bottomPadding = 0;
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.shouldFadeTransitions = NO;
    return onboardingVC;
}


- (NSArray *)onboardingContentViewControllers {
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"WELCOME TO"
                                                                                          subtitle:@"THE HYPE"
                                                                                              body:@"DISCOVER THE MOST EXCLUSIVE EVENTS HAPPENING IN NYC"
                                                                                             image:nil
                                                                                        buttonText:nil
                                                                                            action:^{
                                                                                                
                                                                                            }];
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"CHOOSE THE"
                                                                                           subtitle:@"PERFECT HOST"

                                                                                               body:@"ALL OF OUR HOSTS ARE VETTED PROFESSIONALS WHO KNOW HOW TO THROW THE BEST PARTIES"
                                                                                              image:[UIImage imageNamed:@"OnboardingBackground2"]
                                                                                         buttonText:nil
                                                                                             action:^{
                                                                                                 
                                                                                             }];
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"SUBMIT YOUR"
                                                                                          subtitle:@"GUESTLIST"

                                                                                              body:@"INVITE YOUR FRIENDS TO JOIN THE PARTY AND REQUEST TO BE ADDED TO THE GUESTLIST"
                                                                                             image:[UIImage imageNamed:@"OnboardingBackground3"]
                                                                                        buttonText:nil
                                                                                            action:^{
                                                                                                
                                                                                            }];
    OnboardingContentViewController *fourthPage = [OnboardingContentViewController contentWithTitle:@"GET READY FOR"
                                                                                           subtitle:@"THE PARTY"
                                                                                               body:@"RULE 1: APPROPRIATE ATTIRE\nRULE 2: HOST KNOWS BEST\nRULE 3: VENUE IS KING"
                                                                                              image:[UIImage imageNamed:@"OnboardingBackground4"]
                                                                                         buttonText:nil
                                                                                             action:^{
                                                                                                 
                                                                                             }];
    return @[firstPage,
             secondPage,
             thirdPage,
             fourthPage];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}

@end
