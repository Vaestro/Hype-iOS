//
//  THLWaitlistHomeViewController.m
//  Hype
//
//  Created by Edgar Li on 1/5/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLWaitlistHomeViewController.h"
#import "THLAppearanceConstants.h"
#import "THLActionBarButton.h"
#import "THLActionButton.h"

static const CGFloat kSubmitButtonHeight = 58.0f;
static const CGFloat kLogoImageSize = 75.0f;

@interface THLWaitlistHomeViewController()
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *welcomeMessageLabel;
@property (nonatomic, strong) THLActionButton *submitInvitationCodeButton;
@property (nonatomic, strong) THLActionButton *requestInvitationButton;
@end

@implementation THLWaitlistHomeViewController
#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
    [self bindView];
}

- (void)constructView {
    _backgroundView = [self newBackgroundView];
    _logoImageView = [self newLogoImageView];
    _welcomeMessageLabel = [self newWelcomeMessageLabel];
    _submitInvitationCodeButton = [self newSubmitInvitationCodeButton];
    _requestInvitationButton = [self newRequestInvitationButton];
}

- (void)layoutView {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];

    
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;

    [self.view addSubviews:@[_backgroundView,
                             _logoImageView,
                             _welcomeMessageLabel,
                             _submitInvitationCodeButton,
                             _requestInvitationButton]];
    WEAKSELF();
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(UIEdgeInsetsZero);
    }];
    
    [_requestInvitationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo([WSELF submitInvitationCodeButton].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [_submitInvitationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake1(kLogoImageSize));
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo([WSELF welcomeMessageLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_welcomeMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(SCREEN_WIDTH*0.66);
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(SV([WSELF welcomeMessageLabel]).mas_centerY).insets(kTHLEdgeInsetsHigh());

    }];
}

- (void)bindView {
    _submitInvitationCodeButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handleSubmitInvitationCodeAction];
        return [RACSignal empty];
    }];
    
    _requestInvitationButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handleRequestInvitationAction];
        return [RACSignal empty];
    }];
}

- (void)handleSubmitInvitationCodeAction {
    [_delegate didSelectUseInvitationCode];
}

- (void)handleRequestInvitationAction {
    [_delegate didSelectRequestInvitation];
}

#pragma mark - Constructors

- (UIImageView *)newBackgroundView {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"WaitlistHomeBG"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (UIImageView *)newLogoImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"Hypelist-Icon"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (UILabel *)newWelcomeMessageLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    [label setText:@"Your access to the most exclusive parties in NYC"];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = NO;
    label.numberOfLines = 0;
    return label;
}

- (THLActionButton *)newSubmitInvitationCodeButton {
    THLActionButton *button = [[THLActionButton alloc] initWithDefaultStyle];
    [button setTitle:@"Use Invitation Code"];
    return button;
}

- (THLActionButton *)newRequestInvitationButton {
    THLActionButton *button = [[THLActionButton alloc] initWithInverseStyle];
    [button setTitle:@"Request Invitation"];
    return button;
}


@end