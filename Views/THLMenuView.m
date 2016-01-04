//
//  THLMenuView.m
//  Hype
//
//  Created by Daniel Aksenov on 12/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLMenuView.h"
#import "THLAppearanceConstants.h"

static CGFloat const kTHLRedeemPerkViewSeparatorViewHeight = 1;
static CGFloat const kTHLRedeemPerkViewSeparatorViewWidth = 300;

@interface THLMenuView()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *addGuestsButton;
@property (nonatomic, strong) UIButton *leaveGuestlistButton;
@property (nonatomic, strong) UIButton *eventDetailsButton;
@property (nonatomic, strong) UIButton *contactHostButton;
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
    _nameLabel = [self newNameLabel];
    _addGuestsButton = [self newButtonwithTitle:@"Add Guests"];
    _leaveGuestlistButton = [self newButtonwithTitle:@"Leave Guestlist"];
    _eventDetailsButton = [self newButtonwithTitle:@"View Event Details"];
    _contactHostButton = [self newButtonwithTitle:@"Contact Host"];
    _cancelButton = [self newButtonwithTitle:@"Cancel"];
    _separatorView = [self newSeparatorView];
}

- (void)layoutView {
    self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    self.tintColor = [UIColor blackColor];
    
    [self addSubviews:@[_nameLabel, _addGuestsButton, _leaveGuestlistButton, _eventDetailsButton, _contactHostButton, _cancelButton, _separatorView]];
    
    [_leaveGuestlistButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    WEAKSELF();
    [_addGuestsButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.leaveGuestlistButton.mas_top).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.size.equalTo(CGSizeMake(kTHLRedeemPerkViewSeparatorViewWidth, kTHLRedeemPerkViewSeparatorViewHeight));
        make.bottom.equalTo(WSELF.addGuestsButton.mas_top).insets(kTHLEdgeInsetsHigh());
        //        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.separatorView.mas_top).insets(kTHLEdgeInsetsLow());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_eventDetailsButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.leaveGuestlistButton.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_contactHostButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.eventDetailsButton.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
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
}

#pragma mark - constructors

- (UILabel *)newNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIBoldTitle);
    label.text = @"Guestlist Menu";
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UIButton *)newButtonwithTitle:(NSString *)title {
    UIButton *button = THLNUIButton(kTHLNUIButtonTitle);
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (UIView *)newSeparatorView {
    UIView *view = THLNUIView(kTHLNUIUndef);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}


#pragma mark - layoutUpdates

- (void)hostLayoutUpdate {
    [self.leaveGuestlistButton setHidden:YES];
    
    WEAKSELF();
    [self.eventDetailsButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.addGuestsButton.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
}

- (void)guestLayoutUpdate {
    [self.addGuestsButton setHidden:YES];
    
    WEAKSELF();
    [self.eventDetailsButton remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.offset(0);
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.leaveGuestlistButton remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.eventDetailsButton.top).insets(kTHLEdgeInsetsHigh());
        make.left.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.separatorView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsSuperHigh());
        make.size.equalTo(CGSizeMake(kTHLRedeemPerkViewSeparatorViewWidth, kTHLRedeemPerkViewSeparatorViewHeight));
        make.bottom.equalTo(WSELF.leaveGuestlistButton.mas_top).insets(kTHLEdgeInsetsHigh());
    }];

}


@end
