//
//  THLAlertView.m
//  HypeUp
//
//  Created by Edgar Li on 2/12/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLAlertView.h"
#import "THLAppearanceConstants.h"

@interface THLAlertView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *dismissButton;

@end

@implementation THLAlertView
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
    _dismissButton = [self newDismissButton];
}

- (void)presentView {
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow addSubview:self];
    
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)layoutView {
    [self addSubviews:@[_titleLabel, _messageLabel, _dismissButton]];
    
    WEAKSELF();
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(SV([WSELF titleLabel]).mas_centerY).insets(kTHLEdgeInsetsInsanelyHigh());
        make.centerX.offset(0);
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_messageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF titleLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.offset(0);
        make.width.equalTo(SCREEN_WIDTH*0.66);
    }];
    
    [_dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.insets(kTHLEdgeInsetsInsanelyHigh());
        make.centerX.equalTo(0);
    }];
}


- (void)bindView {
    WEAKSELF();
    RAC(_titleLabel, text) = RACObserve(self, title);
    RAC(_messageLabel, text) = RACObserve(self, message);
    
    [[self.dismissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [WSELF dismiss];
    }];
}

- (void)showWithTitle:(NSString *)title message:(NSString *)message {
    self.title = title;
    self.message = message;
    
    [self presentView];
}

- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)newMessageLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    return label;
}

- (UIButton *)newDismissButton {
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    return button;
}
@end
