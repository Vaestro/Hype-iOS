//
//  THLLoginViewController.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLoginViewController.h"
#import "THLAppearanceConstants.h"
#import "OnboardingViewController.h"
#import "SVProgressHUD.h"
#import "THLResourceManager.h"

static CGFloat const LOGIN_BUTTON_HEIGHT = 50;
static CGFloat const PRIVACY_IMAGEVIEW_DIMENSION = 14;

@interface THLLoginViewController()
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIImageView *privacyImageView;
@property (nonatomic, strong) UILabel *privacyLabel;
@property (nonatomic, strong) UIButton *facebookLoginButton;
@property (nonatomic, strong) UIView *facebookLoginContainerView;
@property (nonatomic, strong) OnboardingViewController *onboardingVC;
@end

@implementation THLLoginViewController
@synthesize showActivityIndicator;
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
    _privacyImageView = [self newPrivacyImageView];
    _privacyLabel = [self newPrivacyLabel];
    _facebookLoginButton = [self newFacebookLoginButton];
    _facebookLoginContainerView = [self newFacebookContainerView];
    _loginButton = [self newLoginButton];
}

- (void)layoutView {
    self.view.backgroundColor = [UIColor blackColor];
    [self addChildViewController:_onboardingVC];
    [self.view addSubview:_onboardingVC.view];
    [_onboardingVC didMoveToParentViewController:self];
    
    [self.view addSubviews:@[_facebookLoginContainerView]];
    
    WEAKSELF();
    [_onboardingVC.view makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(UIEdgeInsetsZero);
        make.bottom.equalTo([WSELF facebookLoginContainerView].mas_top).insets(UIEdgeInsetsZero);
    }];
    
    [_facebookLoginContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(UIEdgeInsetsZero);
        make.bottom.insets(UIEdgeInsetsMake1(35));
    }];
}

- (void)bindView {
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
- (UIButton *)newLoginButton {
    UIButton *button = THLNUIButton(kTHLNUIUndef);
    button.backgroundColor = [UIColor redColor];
    return button;
}

- (UIButton *)newFacebookLoginButton {
    UIButton *button = THLNUIButton(kTHLNUIButtonTitle);
    button.backgroundColor = kTHLNUIBlueColor;
    [button setTitle:@"Login with Facebook" forState:UIControlStateNormal];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = kTHLCornerRadius;
    return button;
}

- (UILabel *)newPrivacyLabel {
    UILabel *label = THLNUILabel(kTHLNUISectionTitle);
    label.alpha = 0.80;
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont systemFontOfSize:12.f];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.1;
    label.text = @"We will never post on your behalf";
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIImageView *)newPrivacyImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"Lock Icon"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (UIView *)newPrivacyContainerView {
    UIView *view = [UIView new];
    [view addSubviews:@[_privacyImageView,
                        _privacyLabel]];
    
    WEAKSELF();
    [_privacyImageView makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake1(PRIVACY_IMAGEVIEW_DIMENSION));
        make.centerY.offset(0);
    }];
    
    [_privacyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF privacyImageView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.centerY.offset(0);
        make.centerX.offset(0);
        make.top.bottom.insets(UIEdgeInsetsZero);
    }];
    
    return view;
}

- (UIView *)newFacebookContainerView {
    UIView *privacyContainerView = [self newPrivacyContainerView];
    
    UIView *view = [UIView new];
    [view addSubviews:@[_facebookLoginButton,
                        privacyContainerView]];
    
    [_facebookLoginButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsHigh());
        make.height.equalTo(LOGIN_BUTTON_HEIGHT);
    }];
    
    WEAKSELF();
    [privacyContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF facebookLoginButton].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.centerX.offset(0);
        make.bottom.insets(kTHLEdgeInsetsNone());
    }];
    
    return view;
}

- (OnboardingViewController *)newOnboardingViewController {
    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundVideoURL:[THLResourceManager onboardingVideo] contents:[self onboardingContentViewControllers]];
    onboardingVC.fontName = @"Raleway-Bold";
    onboardingVC.titleFontSize = 24;
    onboardingVC.subtitleFontSize = 40;
    onboardingVC.bodyFontSize = 24;
    onboardingVC.topPadding = 10;
    onboardingVC.underIconPadding = 67;
    onboardingVC.underTitlePadding = 0;
    onboardingVC.underSubtitlePadding = SCREEN_HEIGHT/4;
    onboardingVC.bottomPadding = 10;
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.shouldFadeTransitions = YES;
    return onboardingVC;
}


- (NSArray *)onboardingContentViewControllers {
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"WELCOME TO"
                                                                                          subtitle:@"THE HYPELIST"
                                                                                              body:@"DISCOVER THE MOST EXCLUSIVE EVENTS HAPPENING IN NYC"
                                                                                             image:nil
                                                                                        buttonText:nil
                                                                                            action:^{
                                                                                                
                                                                                            }];
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"CHOOSE THE"
                                                                                           subtitle:@"PERFECT HOST"

                                                                                               body:@"ALL OF OUR HOSTS ARE VETTED PROFESSIONALS WHO KNOW HOW TO THROW THE BEST PARTIES"
                                                                                              image:nil
                                                                                         buttonText:nil
                                                                                             action:^{
                                                                                                 
                                                                                             }];
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"SUBMIT YOUR"
                                                                                          subtitle:@"GUESTLIST"

                                                                                              body:@"INVITE YOUR FRIENDS TO JOIN THE PARTY AND REQUEST TO BE ADDED TO THE GUESTLIST"
                                                                                             image:nil
                                                                                        buttonText:nil
                                                                                            action:^{
                                                                                                
                                                                                            }];
    OnboardingContentViewController *fourthPage = [OnboardingContentViewController contentWithTitle:@"GET READY FOR"
                                                                                           subtitle:@"THE PARTY"
                                                                                               body:@"RULE 1: APPROPRIATE ATTIRE\nRULE 2: HOST KNOWS BEST\n RULE 3: VENUE IS KING"
                                                                                              image:nil
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
