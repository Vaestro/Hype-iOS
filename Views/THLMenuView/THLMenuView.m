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

@interface THLMenuView()
@property (nonatomic, strong) UILabel *hostNameLabel;
@property (nonatomic, strong) THLPersonIconView *iconImageView;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *addGuestsButton;
@property (nonatomic, strong) UIButton *leaveGuestlistButton;
@property (nonatomic, strong) UIButton *eventDetailsButton;
@property (nonatomic, strong) UIButton *chatHostButton;
@property (nonatomic, strong) UIButton *chatGroupButton;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *hostChatIcon;
@property (nonatomic, strong) UIImageView *groupChatIcon;
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
    _addGuestsButton = [self newButtonwithTitle:@"Add Guests"];
    _leaveGuestlistButton = [self newButtonwithTitle:@"Leave Guestlist"];
    _eventDetailsButton = [self newButtonwithTitle:@"View Event Details"];
    _cancelButton = [self newDismissButton];
    _chatHostButton = [self newButtonwithTitle:@"Chat Host"];
    _chatGroupButton = [self newButtonwithTitle:@"Chat Group"];
    _containerView = [self newContainerView];
    _addIcon = [self newIconNamed:@"Add Icon"];
    _calendarIcon = [self newIconNamed:@"Calendar Icon"];
    _hostChatIcon = [self newIconNamed:@"Chat Icon"];
    _groupChatIcon = [self newIconNamed:@"group_chat"];
    _leaveIcon = [self newIconNamed:@"Leave Icon"];
}

- (void)layoutView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    [self addSubview:_containerView];
    [_containerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(kTHLEdgeInsetsNone());
    }];
    [self.containerView addSubviews:@[_addGuestsButton, _leaveGuestlistButton, _eventDetailsButton, _addIcon, _calendarIcon, _hostChatIcon, _groupChatIcon, _chatHostButton, _chatGroupButton, _leaveIcon, _cancelButton]];

    UIView *personContainerView = [UIView new];
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.text = @"Your Host";
    label.textColor = [UIColor grayColor];
    [personContainerView addSubviews:@[_hostNameLabel, _iconImageView, label]];
    
    WEAKSELF();
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(label.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsNone());
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];

    [_hostNameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo([WSELF iconImageView].mas_bottom).insets(kTHLEdgeInsetsHigh());
    }];

    [self.containerView addSubview:personContainerView];
    
    [personContainerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.centerX.equalTo(0);
    }];
    
    [_addIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.centerY.equalTo([WSELF addGuestsButton].mas_centerY);
    }];
    
    [_addGuestsButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF addIcon].mas_right).insets(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(_hostNameLabel.mas_bottom).offset(50);
    }];

    [_leaveIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.centerY.equalTo([WSELF leaveGuestlistButton].mas_centerY);
    }];
    
    [_leaveGuestlistButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF leaveIcon].mas_right).insets(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(WSELF.addGuestsButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_calendarIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.centerY.equalTo([WSELF eventDetailsButton].mas_centerY);
    }];
    
    [_eventDetailsButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF calendarIcon].mas_right).insets(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(WSELF.leaveGuestlistButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_hostChatIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.centerY.equalTo([WSELF chatHostButton].mas_centerY);
    }];

    [_chatHostButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF hostChatIcon].mas_right).insets(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(WSELF.eventDetailsButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_groupChatIcon makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.centerY.equalTo([WSELF chatGroupButton].mas_centerY);
    }];
    
    [_chatGroupButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF groupChatIcon].mas_right).insets(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(WSELF.chatHostButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
    }];

    [_cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.insets(kTHLEdgeInsetsInsanelyHigh());
        make.centerX.equalTo(0);
    }];
}

- (void)bindView {
    RAC(_cancelButton, rac_command) = RACObserve(self, dismissCommand);
    RAC(_addGuestsButton, rac_command) = RACObserve(self , menuAddGuestsCommand);
    RAC(_leaveGuestlistButton, rac_command) = RACObserve(self, menuLeaveGuestCommand);
    RAC(_eventDetailsButton, rac_command) = RACObserve(self, menuEventDetailsCommand);
    RAC(_chatHostButton, rac_command) = RACObserve(self, menuChatHostCommand);
    RAC(_chatGroupButton, rac_command) = RACObserve(self, menuChatGroupCommand);
    RAC(_iconImageView, imageURL) = RACObserve(self, hostImageURL);
    RAC(_hostNameLabel, text) = RACObserve(self, hostName);
}

#pragma mark - constructors

- (THLPersonIconView *)newIconImageView {
    THLPersonIconView *iconView = [THLPersonIconView new];
    return iconView;
}

- (UILabel *)newHostNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (UIButton *)newButtonwithTitle:(NSString *)title {
    UIButton *button = THLNUIButton(kTHLNUIRegularTitle);
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (UIView *)newContainerView {
    UIView *view = THLNUIView(kTHLNUIUndef);
    return view;
}

- (UIImageView *)newIconNamed:(NSString *)iconName {
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:iconName]];
    return image;
}

- (UIButton *)newDismissButton {
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    return button;
}


#pragma mark - layoutUpdates

- (void)hostLayoutUpdate {
    [self.leaveGuestlistButton setHidden:YES];
    [self.leaveIcon setHidden:YES];
    [self.chatHostButton setHidden:YES];
    [self.hostChatIcon setHidden:YES];
    [self.chatGroupButton setHidden:YES];
    [self.groupChatIcon setHidden:YES];
    
    WEAKSELF();
    [_calendarIcon remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.centerY.equalTo([WSELF eventDetailsButton].mas_centerY);
    }];
    
    [_eventDetailsButton remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF calendarIcon].mas_right).insets(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(WSELF.addGuestsButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_chatHostButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.eventDetailsButton.mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(WSELF.hostChatIcon.mas_right).insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [_hostChatIcon remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.centerY.equalTo([WSELF chatHostButton].mas_centerY);
    }];
}

- (void)partyLeadLayoutUpdate {
    [self.leaveGuestlistButton setHidden:YES];
    [self.leaveIcon setHidden:YES];
    [self.chatHostButton setHidden:YES];
    [self.hostChatIcon setHidden:YES];
    [self.chatGroupButton setHidden:YES];
    [self.groupChatIcon setHidden:YES];
    
    WEAKSELF();
    [_calendarIcon remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kTHLEdgeInsetsInsanelyHigh());
        make.centerY.equalTo([WSELF eventDetailsButton].mas_centerY);
    }];
    
    [_eventDetailsButton remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([WSELF calendarIcon].mas_right).insets(kTHLEdgeInsetsSuperHigh());
        make.top.equalTo(WSELF.addGuestsButton.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
    }];

}

- (void)guestLayoutUpdate {
    [self.chatHostButton setHidden:YES];
    [self.hostChatIcon setHidden:YES];
    [self.chatGroupButton setHidden:YES];
    [self.groupChatIcon setHidden:YES];
}


@end
