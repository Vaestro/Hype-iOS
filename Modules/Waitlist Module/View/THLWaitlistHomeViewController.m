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

static const CGFloat kSubmitButtonHeight = 58.0f;
static const CGFloat kLogoImageSize = 75.0f;

@interface THLWaitlistHomeViewController()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *welcomeMessageLabel;
@property (nonatomic, strong) THLActionBarButton *submitInvitationCodeButton;
@property (nonatomic, strong) THLActionBarButton *requestInvitationButton;
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
    _logoImageView = [self newLogoImageView];
    _welcomeMessageLabel = [self newWelcomeMessageLabel];
    _submitInvitationCodeButton = [self newSubmitInvitationCodeButton];
    _requestInvitationButton = [self newRequestInvitationButton];
}

- (void)layoutView {
    self.view.backgroundColor = kTHLNUISecondaryBackgroundColor;

    [self.view addSubviews:@[_logoImageView,
                             _welcomeMessageLabel,
                             _submitInvitationCodeButton,
                             _requestInvitationButton]];
    WEAKSELF();
    [_requestInvitationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
        make.top.equalTo([WSELF submitInvitationCodeButton].mas_bottom);
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [_submitInvitationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.insets(kTHLEdgeInsetsNone());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake1(kLogoImageSize));
        make.centerX.mas_equalTo(0);
        make.top.insets(UIEdgeInsetsMake1(70));
    }];
    
    [_welcomeMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(SCREEN_WIDTH*0.66);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
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

- (THLActionBarButton *)newSubmitInvitationCodeButton {
    THLActionBarButton *button = [THLActionBarButton new];
    [button setTitle:@"Use Invitation Code" forState:UIControlStateNormal];
    [button setBackgroundColor:kTHLNUIAccentColor];
    return button;
}

- (THLActionBarButton *)newRequestInvitationButton {
    THLActionBarButton *button = [THLActionBarButton new];
    [button setTitle:@"Request Invitation" forState:UIControlStateNormal];
    [button setBackgroundColor:kTHLNUIAccentColor];
    [button setAlpha:0.75];
    return button;
}


@end