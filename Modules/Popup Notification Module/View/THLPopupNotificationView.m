//
//  THLGuestlistInviteModalView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPopupNotificationView.h"
#import "THLPersonIconView.h"
#import "THLActionBarButton.h"
#import "UITextView+NUI.h"
#import "THLAppearanceConstants.h"

static CGFloat const ICON_VIEW_DIMENSION = 50;

@interface THLPopupNotificationView()
@property (nonatomic, strong) THLPersonIconView *iconView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) THLActionBarButton *button;
@end


@implementation THLPopupNotificationView
@synthesize acceptCommand = _acceptCommand;
@synthesize notificationText = _notificationText;
@synthesize imageURL = _imageURL;
@synthesize image = _image;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)constructView {
    self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    
    _iconView = [self newIconView];
    _textView = [self newTextView];
    _button = [self newButton];
}

- (void)layoutView {
    [self addSubviews:@[_iconView,
                        _textView,
                        _button]];
    
    WEAKSELF();
    [_iconView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsHigh());
        make.centerX.equalTo(0);
        make.height.equalTo(ICON_VIEW_DIMENSION);
        make.width.equalTo([WSELF iconView].mas_height);
    }];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF iconView].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsHigh());
        make.width.equalTo(ScreenWidth-4*kTHLInset);
        make.bottom.insets(kTHLEdgeInsetsHigh());
    }];
    
    if (_button.rac_command != nil) {
        [_button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF textView].mas_bottom).insets(kTHLEdgeInsetsHigh());
            make.left.right.bottom.insets(kTHLEdgeInsetsHigh());
        }];
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)bindView {
    RAC(self.iconView, imageURL) = RACObserve(self, imageURL);
    RAC(self.iconView, image) = RACObserve(self, image);
    RAC(self.textView, text) = RACObserve(self, notificationText);
    RAC(self.button, rac_command) = RACObserve(self, acceptCommand);
}

#pragma mark - Constructors
- (THLPersonIconView *)newIconView {
    THLPersonIconView *iconView = [THLPersonIconView new];
    return iconView;
}

- (UITextView *)newTextView {
    UITextView *textView = THLNUITextView(kTHLNUIDetailTitle);
    [textView setScrollEnabled:NO];
    [textView setEditable:NO];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.userInteractionEnabled = NO;
    textView.backgroundColor = [UIColor clearColor];
    return textView;
}

- (THLActionBarButton *)newButton {
    THLActionBarButton *button = [THLActionBarButton new];
    [button setTitle:@"VIEW EVENT" animateChanges:NO];
    return button;
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}
@end
