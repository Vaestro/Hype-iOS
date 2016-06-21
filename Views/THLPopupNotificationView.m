//
//  THLGuestlistInviteModalView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPopupNotificationView.h"
#import "THLPersonIconView.h"
#import "THLActionButton.h"
#import "UITextView+NUI.h"
#import "THLAppearanceConstants.h"

@interface THLPopupNotificationView()
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) THLPersonIconView *iconView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) THLActionButton *button;
@end

@implementation THLPopupNotificationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    WEAKSELF();
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
        make.bottom.equalTo(WSELF.mas_centerY).insets(kTHLEdgeInsetsHigh());
    }];
    
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(WSELF.imageView.mas_bottom);
        make.centerX.equalTo(0);
        make.height.equalTo(WSELF.frame.size.width*0.30);
        make.width.equalTo([WSELF iconView].mas_height);
    }];
    
    [self.messageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF iconView].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsHigh());
        make.width.equalTo(ScreenWidth-4*kTHLInset);
    }];

    [self.button makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF messageLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.bottom.insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)setMessageLabelText:(NSString *)text {
    [self.messageLabel setText:text];
}

- (void)setButtonTitle:(NSString *)title {
    [self.button.titleLabel setText:title];
}

- (void)setButtonTarget:(nullable id)target action:(nonnull SEL)selector forControlEvents:(UIControlEvents)event  {
    [self.button addTarget:target action:selector forControlEvents:event];
}

- (void)setIconURL:(NSURL *)url {
    [self.iconView setImageURL:url];
}

- (void)setImageViewWithURL:(NSURL *)url {
    [self.imageView sd_setImageWithURL:url];
}

#pragma mark - Constructors
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (THLPersonIconView *)iconView {
    if (!_iconView) {
        _iconView = [THLPersonIconView new];
        [self addSubview:_iconView];
    }
    return _iconView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = THLNUILabel(kTHLNUIDetailTitle);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.backgroundColor = [UIColor clearColor];

        [self addSubview:_messageLabel];
    }

    return _messageLabel;
}

- (THLActionButton *)button {
    if (!_button) {
        _button = [[THLActionButton alloc] initWithDefaultStyle];
        [_button setTitle:@"VIEW EVENT"];
        [self addSubview:_button];
    }
    return _button;
}
@end
