//
//  THLConfirmationPopupView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/5/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLConfirmationPopupView.h"
#import "THLActionBarButton.h"
#import "THLAppearanceConstants.h"

@interface THLConfirmationPopupView()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) THLActionBarButton *confirmButton;
@property (nonatomic, strong) THLActionBarButton *cancelButton;
@end


@implementation THLConfirmationPopupView
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
    
    _textView = [self newTextView];
    _confirmButton = [self newConfirmButton];
    _cancelButton = [self newCancelButton];
}

- (void)layoutView {
    [self addSubviews:@[_textView,
                        _confirmButton,
                        _cancelButton]];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsHigh());
        make.width.equalTo(ScreenWidth-4*kTHLInset);
    }];
    
    [_confirmButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.left.insets(UIEdgeInsetsZero).insets(kTHLEdgeInsetsHigh());
        make.right.equalTo(_cancelButton.mas_left).insets(kTHLEdgeInsetsHigh());
        make.width.equalTo(_cancelButton);
    }];
    
    [_cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.right.bottom.insets(UIEdgeInsetsZero).insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)bindView {
    WEAKSELF();
    RAC(WSELF.textView, text) = RACObserve(WSELF, confirmationText);
    RAC(WSELF.confirmButton, rac_command) = RACObserve(WSELF, confirmCommand);
    [[WSELF.confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [WSELF dismissPresentingPopup];
    }];
    [[WSELF.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [WSELF dismissPresentingPopup];
    }];
}

#pragma mark - Constructors
- (UITextView *)newTextView {
    UITextView *textView = THLNUITextView(kTHLNUIDetailTitle);
    [textView setScrollEnabled:NO];
    [textView setEditable:NO];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.userInteractionEnabled = NO;
    textView.backgroundColor = [UIColor clearColor];
    return textView;
}

- (THLActionBarButton *)newConfirmButton {
    THLActionBarButton *confirmButton = [THLActionBarButton new];
    [confirmButton setTitle:@"YES" animateChanges:NO];
    confirmButton.backgroundColor = kTHLNUIAccentColor;
    return confirmButton;
}

- (THLActionBarButton *)newCancelButton {
    THLActionBarButton *cancelButton = [THLActionBarButton new];
    [cancelButton setTitle:@"NO" animateChanges:NO];
    cancelButton.backgroundColor = kTHLNUIRedColor;
    
    return cancelButton;
}
@end