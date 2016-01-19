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
#import "THLActionBarButton.h"

@interface THLLoginViewController()
@property (nonatomic, strong) UIBarButtonItem *dismissButton;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIButton *facebookLoginButton;
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
    _dismissButton = [self newDismissButton];
    _bodyLabel = [self newBodyLabel];
    _facebookLoginButton = [self newFacebookLoginButton];
}

- (void)layoutView {
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = _dismissButton;
    self.navigationItem.title = @"LOG IN";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:kTHLNUIPrimaryFontColor,
       NSFontAttributeName:[UIFont fontWithName:@"Raleway-Regular" size:21]}];
    
    [self.view addSubviews:@[_backgroundView, _bodyLabel, _facebookLoginButton]];
    
//    WEAKSELF();
    [_backgroundView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.insets(UIEdgeInsetsZero);
    }];
    
    [_bodyLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.centerY.equalTo(0);
    }];
    
    [_facebookLoginButton makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(60);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.insets(UIEdgeInsetsMake1(35));
    }];
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

#pragma mark - Constructors
- (UILabel *)newBodyLabel {
    UILabel *label =  [UILabel new];
    [label setFont:[UIFont fontWithName:@"Raleway-Bold" size:48]];
    label.textColor = kTHLNUIPrimaryFontColor;
    label.text = @"GET\nREADY\nFOR\nTHE\nPARTY";
    label.numberOfLines = 5;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UIImageView *)newBackgroundView {
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setImage:[UIImage imageNamed:@"LoginBackground"]];
    return imageView;
}

- (UIBarButtonItem *)newDismissButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Cancel X Icon"] style:UIBarButtonItemStylePlain target:nil action:NULL];
    [item setTintColor:kTHLNUIGrayFontColor];
    [item setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      kTHLNUIGrayFontColor, NSForegroundColorAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

- (UIButton *)newFacebookLoginButton {
    UIButton *loginButton = [UIButton new];
    loginButton.backgroundColor = kTHLNUIBlueColor;
    [loginButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    [loginButton setTitleColor:kTHLNUIPrimaryFontColor forState:UIControlStateNormal];
    return loginButton;
}

@end