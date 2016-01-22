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
@property (nonatomic, strong) OnboardingViewController *onboardingVC;
@end

@implementation THLOnboardingViewController
@synthesize showActivityIndicator;
@synthesize skipCommand;
@synthesize loginCommand;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)constructView {
    _onboardingVC = [self newOnboardingViewController];
}

- (void)layoutView {
    self.view.backgroundColor = [UIColor blackColor];
    [self addChildViewController:_onboardingVC];
    [_onboardingVC didMoveToParentViewController:self];
    
    [self.view addSubviews:@[_onboardingVC.view]];
    
    [_onboardingVC.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(UIEdgeInsetsZero);
    }];
}

- (void)bindView {
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
- (OnboardingViewController *)newOnboardingViewController {
    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundVideoURL:[THLResourceManager onboardingVideo] contents:[self onboardingContentViewControllers]];
    onboardingVC.fontName = @"Raleway-Bold";
    onboardingVC.titleFontSize = 24;
    onboardingVC.subtitleFontSize = 36;
    onboardingVC.bodyFontSize = 24;
    onboardingVC.topPadding = 0;
    onboardingVC.underIconPadding = SCREEN_HEIGHT*0.067;
    onboardingVC.underTitlePadding = 0;
    onboardingVC.underSubtitlePadding = SCREEN_HEIGHT*0.2;
    onboardingVC.bottomPadding = -10;
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.shouldFadeTransitions = NO;
    return onboardingVC;
}

- (NSArray *)onboardingContentViewControllers {
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"WELCOME TO"
                                                                                          subtitle:@"THE HYPEUP"
                                                                                              body:@"DISCOVER THE MOST EXCLUSIVE EVENTS HAPPENING IN NYC"
                                                                                             image:nil
                                                                                        buttonText:nil
                                                                                            action:nil
                                                                                secondaryButtonText:@"Swipe to Continue"
                                                                                   secondaryAction:nil];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"DESIGN THE"
                                                                                           subtitle:@"PERFECT NIGHT"
                                                                                               body:@"INVITE YOUR FRIENDS TO JOIN YOUR GUEST LIST FOR THE EVENT OF YOUR CHOICE AND GET COMPLIMENTARY VIP BENEFITS"
                                                                                              image:[UIImage imageNamed:@"OnboardingBackground2"]
                                                                                         buttonText:nil
                                                                                             action:nil
                                                                                secondaryButtonText:nil
                                                                                    secondaryAction:nil];
    
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"EARN GREAT"
                                                                                          subtitle:@"PERKS"
                                                                                              body:@"FOR EACH FRIEND THAT ATTENDS YOUR EVENT, YOU WILL GET CREDITS REDEEMABLE FOR PERKS LIKE A LIMO RIDE"
                                                                                             image:[UIImage imageNamed:@"OnboardingBackground3"]
                                                                                        buttonText:nil
                                                                                            action:nil
                                                                               secondaryButtonText:nil
                                                                                   secondaryAction:nil];
    
    OnboardingContentViewController *fourthPage = [OnboardingContentViewController contentWithTitle:@"GET READY FOR"
                                                                                           subtitle:@"THE PARTY"
                                                                                               body:@"OUR HOSTS WILL ANSWER ANY QUESTIONS YOU HAVE AND MEET YOU THERE, SO YOU ARE ENSURED A SMOOTH AND HYPE NIGHT"
                                                                                              image:[UIImage imageNamed:@"OnboardingBackground4"]
                                                                                         buttonText:@"Login with facebook"
                                                                                             action:^{
                                                                                                 [loginCommand execute:nil];
                                                                                             }
                                                                                secondaryButtonText:@"I'll signup later"
                                                                                    secondaryAction:^{
                                                                                                    [skipCommand execute:nil];
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
