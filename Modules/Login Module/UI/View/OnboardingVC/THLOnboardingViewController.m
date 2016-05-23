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
    onboardingVC.bodyFontSize = 18;
    onboardingVC.topPadding = 0;
    onboardingVC.underIconPadding = SCREEN_HEIGHT*0.067;
    onboardingVC.underTitlePadding = 0;
    onboardingVC.underSubtitlePadding = SCREEN_HEIGHT*0.2;
    onboardingVC.bottomPadding = -10;
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.shouldFadeTransitions = YES;
    return onboardingVC;
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
                                                                                               body:@"For each friend that attends your event, you will get credits redeemable for perks like a free limo ride."
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
                                                    [loginCommand execute:nil];
                                                   }
                                                   secondaryButtonText:@"I'll signup later"
                                                   secondaryAction:^{
                                                       [skipCommand execute:nil];
                                                   }];
    
    return @[firstPage,
             secondPage,
             thirdPage,
             fourthPage,
             fifthPage];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}

@end
