//
//  THLCreditsExplanationView.m
//  HypeUp
//
//  Created by Edgar Li on 2/14/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLCreditsExplanationView.h"
#import "THLAppearanceConstants.h"
#import "THLActionButton.h"

@interface THLCreditsExplanationView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *explanationLabel;
@property (nonatomic, strong) UILabel *secondExplanationLabel;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIImageView *numberOneIcon;
@property (nonatomic, strong) UIImageView *numberTwoIcon;

@property (nonatomic, strong) THLActionButton *discoverEventsButton;
@property (nonatomic, strong) THLActionButton *inviteFriendsButton;
@end

@implementation THLCreditsExplanationView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        self.tintColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _titleLabel = [self newTitleLabel];
    _messageLabel = [self newMessageLabel];
    _explanationLabel = [self newExplanationLabel];
    _secondExplanationLabel = [self newSecondExplanationLabel];
    _discoverEventsButton = [self newDiscoverEventsButton];
    _inviteFriendsButton = [self newInviteFriendsButton];
    _dismissButton = [self newDismissButton];
    _numberOneIcon = [self newNumberOneIcon];
    _numberTwoIcon = [self newNumberTwoIcon];
}

- (void)show {
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = [UIScreen mainScreen].bounds;
    [mainWindow addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)layoutView {
    [self addSubviews:@[_titleLabel,
                        _messageLabel,
                        _explanationLabel,
                        _secondExplanationLabel,
                        _dismissButton,
                        _discoverEventsButton,
                        _inviteFriendsButton,
                        _numberOneIcon,
                        _numberTwoIcon]];
    
    WEAKSELF();
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF messageLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.right.insets(kTHLEdgeInsetsNone());
        make.left.equalTo([WSELF discoverEventsButton]);
    }];
    
    [_messageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF explanationLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.width.equalTo(SCREEN_WIDTH*0.66);
        make.left.equalTo([WSELF discoverEventsButton]);
    }];
    
    [_numberOneIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo([WSELF explanationLabel].mas_centerY);
        make.left.equalTo([WSELF discoverEventsButton]);
    }];
    
    [_explanationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF secondExplanationLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.left.equalTo([WSELF numberOneIcon].mas_right).insets(kTHLEdgeInsetsHigh());
        make.width.equalTo(SCREEN_WIDTH*0.66);
    }];

    [_numberTwoIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo([WSELF secondExplanationLabel].mas_centerY);
        make.left.equalTo([WSELF discoverEventsButton]);
    }];
    
    [_secondExplanationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF discoverEventsButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.left.equalTo([WSELF numberTwoIcon].mas_right).insets(kTHLEdgeInsetsHigh());
        make.width.equalTo(SCREEN_WIDTH*0.66);
    }];
    
    [_dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsInsanelyHigh());
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_discoverEventsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(SCREEN_WIDTH*0.80);
        make.bottom.equalTo([WSELF inviteFriendsButton].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
    
    [_inviteFriendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.insets(kTHLEdgeInsetsInsanelyHigh());
        make.width.equalTo(SCREEN_WIDTH*0.80);
        make.top.equalTo([WSELF discoverEventsButton].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.height.mas_equalTo(kSubmitButtonHeight);
    }];
}


- (void)bindView {
    _dismissButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self dismiss];
        return [RACSignal empty];
    }];
    
    RAC(self.discoverEventsButton, rac_command) = RACObserve(self, discoverEventsCommand);
    RAC(self.inviteFriendsButton, rac_command) = RACObserve(self, inviteFriendsCommand);
}

- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"Credits";
    return label;
}

- (UILabel *)newMessageLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"Earn credits to redeem for perks with:";
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    return label;
}

- (UILabel *)newExplanationLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"Each friend you invite to attend an event";
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    return label;
}

- (UILabel *)newSecondExplanationLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"Inviting friends to join the app and you both get credits when they attend their first event";
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    return label;
}

- (THLActionButton *)newDiscoverEventsButton {
    THLActionButton *button = [[THLActionButton alloc] initWithDefaultStyle];
    [button setTitle:@"Find an event"];
    return button;
}

- (THLActionButton *)newInviteFriendsButton {
    THLActionButton *button = [[THLActionButton alloc] initWithInverseStyle];
    [button setTitle:@"Invite friends"];
    return button;
}

- (UIButton *)newDismissButton {
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    return button;
}

- (UIImageView *)newNumberOneIcon {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"number_one_icon"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

- (UIImageView *)newNumberTwoIcon {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"number_two_icon"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}


@end
