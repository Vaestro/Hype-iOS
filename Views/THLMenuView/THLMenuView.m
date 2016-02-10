//
//  THLMenuView.m
//  Hype
//
//  Created by Daniel Aksenov on 12/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLMenuView.h"
#import "THLAppearanceConstants.h"
#import "THLPersonIconView.h"

static CGFloat const kTHLRedeemPerkViewSeparatorViewHeight = 0.5;
static CGFloat const kTHLRedeemPerkViewSeparatorViewWidth = 300;

@interface THLMenuView()
@property (nonatomic, strong) UILabel *menuTitleLabel;
@property (nonatomic, strong) UILabel *hostNameLabel;
@property (nonatomic, strong) THLPersonIconView *iconImageView;

@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *addGuestsButton;
@property (nonatomic, strong) UIButton *leaveGuestlistButton;
@property (nonatomic, strong) UIButton *eventDetailsButton;
@property (nonatomic, strong) UIButton *contactHostButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *contactIcon;
@property (nonatomic, strong) UIImageView *addIcon;
@property (nonatomic, strong) UIImageView *leaveIcon;
@property (nonatomic, strong) UIImageView *calendarIcon;

@end

@implementation THLMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _iconImageView = [self newIconImageView];
    _hostNameLabel = [self newHostNameLabel];
    _menuTitleLabel = [self newMenuTitleLabel];
    _addGuestsButton = [self newButtonwithTitle:@"Add Guests"];
    _leaveGuestlistButton = [self newButtonwithTitle:@"Leave Guestlist"];
    _eventDetailsButton = [self newButtonwithTitle:@"View Event Details"];
    _contactHostButton = [self newButtonwithTitle:@"Contact Host"];
    _cancelButton = [self newButtonwithTitle:@"Cancel"];
    _separatorView = [self newSeparatorView];
    _containerView = [self newContainerView];
    _addIcon = [self newIconNamed:@"Add Icon"];
    _calendarIcon = [self newIconNamed:@"Calendar Icon"];
    _contactIcon = [self newIconNamed:@"Chat Icon"];
    _leaveIcon = [self newIconNamed:@"Leave Icon"];
}

- (void)layoutView {
    self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    self.tintColor = [UIColor blackColor];
    [self addSubview:_containerView];
    [_containerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(kTHLEdgeInsetsNone());
    }];
//    _containerView.alpha = 1.0;
//    _containerView.transform = CGAffineTransformIdentity;
//    CGRect startFrame = self.frame;
//    startFrame.origin.y = CGRectGetHeight(self.bounds);
//    _containerView.frame = startFrame;
//    static NSInteger const kAnimationOptionCurveIOS7 = (7 << 16);
//
//    [UIView animateWithDuration:0.30
//                          delay:0
//                        options:kAnimationOptionCurveIOS7 // note: this curve ignores durations
//                     animations:^{
//                         _containerView.frame = self.frame;
//                     }
//                     completion:NULL];
    
    [self.containerView addSubviews:@[_menuTitleLabel, _addGuestsButton, _leaveGuestlistButton, _eventDetailsButton, _contactHostButton, _cancelButton, _separatorView, _addIcon, _calendarIcon, _contactIcon, _leaveIcon]];
    WEAKSELF();

    UIView *personContainerView = [UIView new];
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.text = @"Your Host";
    label.textColor = [UIColor grayColor];
    [personContainerView addSubviews:@[_hostNameLabel, _iconImageView, label]];
    
    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.insets(kTHLEdgeInsetsNone());
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];

    [_hostNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.right.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo(label.mas_top).insets(kTHLEdgeInsetsNone());
    }];
    
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.bottom.equalTo([WSELF iconImageView].mas_bottom);
        make.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [self.containerView addSubview:personContainerView];
    
    [personContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.left.equalTo(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_menuTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.iconImageView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsHigh());
        make.size.equalTo(CGSizeMake(kTHLRedeemPerkViewSeparatorViewWidth, kTHLRedeemPerkViewSeparatorViewHeight));
        make.top.equalTo(WSELF.menuTitleLabel.mas_bottom).insets(kTHLEdgeInsetsLow());
    }];
    
    [_addIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.separatorView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_addGuestsButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.separatorView.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(WSELF.addIcon.mas_right).insets(kTHLEdgeInsetsHigh());
    }];

    
    [_leaveIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.addGuestsButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_leaveGuestlistButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.addGuestsButton.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(WSELF.leaveIcon.mas_right).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_calendarIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.leaveGuestlistButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_eventDetailsButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.leaveGuestlistButton.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(WSELF.calendarIcon.mas_right).insets(kTHLEdgeInsetsHigh());
    }];
    
    
    [_contactIcon makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.eventDetailsButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_contactHostButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.eventDetailsButton.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(WSELF.contactIcon.mas_right).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.bottom.insets(kTHLEdgeInsetsSuperHigh());
    }];
}

- (void)bindView {
    RAC(_cancelButton, rac_command) = RACObserve(self, dismissCommand);
    RAC(_addGuestsButton, rac_command) = RACObserve(self , menuAddGuestsCommand);
    RAC(_leaveGuestlistButton, rac_command) = RACObserve(self, menuLeaveGuestCommand);
    RAC(_eventDetailsButton, rac_command) = RACObserve(self, menuEventDetailsCommand);
    RAC(_contactHostButton, rac_command) = RACObserve(self, menuContactHostCommand);
    RAC(_iconImageView, imageURL) = RACObserve(self, hostImageURL);
    RAC(_hostNameLabel, text) = RACObserve(self, hostName);
}

#pragma mark - constructors

- (THLPersonIconView *)newIconImageView {
    THLPersonIconView *iconView = [THLPersonIconView new];
    return iconView;
}

- (UILabel *)newHostNameLabel {
    UILabel *label = [UILabel new];
    [label setFont:[UIFont systemFontOfSize:48]];
    [label setTextColor:kTHLNUIAccentColor];
    
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UILabel *)newMenuTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.text = @"Guestlist Menu";
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UIButton *)newButtonwithTitle:(NSString *)title {
    UIButton *button = THLNUIButton(kTHLNUIRegularTitle);
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (UIView *)newSeparatorView {
    UIView *view = THLNUIView(kTHLNUIUndef);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UIView *)newContainerView {
    UIView *view = THLNUIView(kTHLNUIUndef);
    return view;
}

- (UIImageView *)newIconNamed:(NSString *)iconName {
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
    return image;
}


#pragma mark - layoutUpdates

- (void)hostLayoutUpdate {
    [self.leaveGuestlistButton setHidden:YES];
    [self.leaveIcon setHidden:YES];
    
    WEAKSELF();
    [self.calendarIcon remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.addGuestsButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.eventDetailsButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.addGuestsButton.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(WSELF.calendarIcon.mas_right).insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)guestLayoutUpdate {
    [self.contactHostButton setHidden:YES];
    [self.contactIcon setHidden:YES];
}


@end
