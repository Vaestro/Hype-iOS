//
//  THLRedeemPerkView.m
//  Hype
//
//  Created by Daniel Aksenov on 12/19/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLConfirmationView.h"
#import "THLAppearanceConstants.h"

static CGFloat const kTHLRedeemPerkViewSeparatorViewHeight = 0.5;
static CGFloat const kTHLRedeemPerkViewSeparatorViewWidth = 300;
static CGFloat const kTHLConfirmationViewButtonHeight = 50;


@interface THLConfirmationView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *checkIconView;
@property (nonatomic, strong) UIView *underlineView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *declineButton;

@property (nonatomic, strong) UIButton *dismissButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end


@implementation THLConfirmationView
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
    _checkIconView = [self newCheckIconView];
    _messageLabel = [self newMessageLabel];
    _acceptButton = [self newAcceptButton];
    _declineButton = [self newDeclineButton];
    
    _dismissButton = [self newDismissButton];
    _underlineView = [self newUnderlineView];
    
    _activityView = [self newActivityView];
}

- (void)showResponseFlowWithTitle:(NSString *)title message:(NSString *)message {
    self.confirmationTitle = title;
    self.confirmationMessage = message;
    
    [_acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
    [_declineButton setTitle:@"Decline" forState:UIControlStateNormal];
    
    [self layoutResponseView];
    [self presentView];
}

- (void)showConfirmationWithTitle:(NSString *)title message:(NSString *)message {
    self.confirmationTitle = title;
    self.confirmationMessage = message;
    
    [self layoutConfirmationView];
    [self presentView];
}

- (void)showInProgressWithMessage:(NSString *)messageText {
    self.confirmationMessage = messageText;
    [self layoutPendingView];
}

- (void)showSuccessWithTitle:(NSString *)titleText Message:(NSString *)messageText {
    self.confirmationTitle = titleText;
    self.confirmationMessage = messageText;
    [self layoutSuccessView];
}

- (void)presentView {
    // Prepare by adding to the top window.
    if(!self.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self];
                
                break;
            }
        }
    }
    
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)dismissResponseFlow {
    [self removeFromSuperview];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)layoutView {
    [self addSubviews:@[_titleLabel, _underlineView, _messageLabel, _dismissButton, _acceptButton, _declineButton]];
    [_underlineView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-75);
        make.size.equalTo(CGSizeMake(kTHLRedeemPerkViewSeparatorViewWidth, kTHLRedeemPerkViewSeparatorViewHeight));
    }];
    
    WEAKSELF();
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.underlineView.mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.offset(0);
        make.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    [_messageLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WSELF.underlineView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.offset(0);
        make.width.equalTo(SCREEN_WIDTH*0.66);
    }];
    
    [_acceptButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF messageLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.width.equalTo(SCREEN_WIDTH*0.66);
        make.height.equalTo(kTHLConfirmationViewButtonHeight);
        make.centerX.offset(0);
    }];
    
    [_declineButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF acceptButton].mas_bottom);
        make.width.equalTo([WSELF acceptButton].mas_width);
        make.height.equalTo([WSELF acceptButton].mas_height);
        make.centerX.offset(0);
    }];
    
    [_dismissButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.insets(kTHLEdgeInsetsInsanelyHigh());
        make.centerX.equalTo(0);
    }];
}

- (void)layoutResponseView {
    WEAKSELF();
    [_acceptButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF messageLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.width.equalTo(SCREEN_WIDTH*0.66);
        make.height.equalTo(kTHLConfirmationViewButtonHeight);
        make.centerX.offset(0);
    }];
    
    [_declineButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF acceptButton].mas_bottom);
        make.width.equalTo([WSELF acceptButton].mas_width);
        make.height.equalTo([WSELF acceptButton].mas_height);
        make.centerX.offset(0);
    }];
    
    
    if (_acceptButton.hidden == YES) {
        _acceptButton.hidden = NO;
        _declineButton.hidden = NO;
    }
}

- (void)layoutConfirmationView {
    WEAKSELF();
    [_declineButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF messageLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.right.equalTo([WSELF mas_centerX]).insets(kTHLEdgeInsetsHigh());
        make.width.equalTo(125);
        make.height.equalTo(kTHLConfirmationViewButtonHeight);
    }];
    
    [_acceptButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF messageLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.left.equalTo([WSELF mas_centerX]).insets(kTHLEdgeInsetsHigh());
        make.width.equalTo([WSELF declineButton].mas_width);
        make.height.equalTo([WSELF declineButton].mas_height);
    }];
    
    self.acceptButton.rac_command = _acceptCommand;
    
    [_acceptButton setTitle:@"YES" forState:UIControlStateNormal];
    [_declineButton setTitle:@"NO" forState:UIControlStateNormal];
    
    
    if (_acceptButton.hidden == YES) {
        _acceptButton.hidden = NO;
        _declineButton.hidden = NO;
    }
}

- (void)layoutPendingView {
    _dismissButton.hidden = YES;

    [UIView animateWithDuration:0.1
                     animations:^{
                         _acceptButton.frame = CGRectZero;
                         _declineButton.frame = CGRectZero;
                     } completion:^(BOOL finished) {
                         _acceptButton.hidden = YES;
                         _declineButton.hidden = YES;
                     }];
    
    
    [self addSubview:_activityView];
    
    WEAKSELF();
    [_activityView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF messageLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.equalTo(0);
    }];
    
    [_activityView startAnimating];
}

- (void)layoutSuccessView {
    _dismissButton.hidden = NO;

    [UIView animateWithDuration:0.1
                     animations:^{
                         _activityView.frame = CGRectZero;
                     } completion:^(BOOL finished) {
                         _activityView.hidden = YES;
                     }];
    
    [_activityView stopAnimating];
    
    [self addSubview:_checkIconView];

    WEAKSELF();
    [_checkIconView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF messageLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.equalTo(0);
    }];
    
    self.dismissButton.rac_command = _dismissCommand;
}

- (void)bindView {
    WEAKSELF();
    RAC(_titleLabel, text) = RACObserve(self, confirmationTitle);
    RAC(_messageLabel, text) = RACObserve(self, confirmationMessage);

    [RACObserve(WSELF, declineButtonText) subscribeNext:^(id _) {
        [_declineButton setTitle:_declineButtonText forState:UIControlStateNormal];
    }];
    
    [RACObserve(WSELF, acceptButtonText) subscribeNext:^(id _) {
        [_acceptButton setTitle:_acceptButtonText forState:UIControlStateNormal];
    }];
    
    RAC(self.acceptButton, rac_command) = RACObserve(WSELF, acceptCommand);
    RAC(self.declineButton, rac_command) = RACObserve(WSELF, declineCommand);

    
    [[self.dismissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [WSELF dismiss];
    }];
}

- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIImageView *)newCheckIconView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Clear Check"]];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

- (UIView *)newUnderlineView {
    UIView *view = THLNUIView(kTHLNUIUndef);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UILabel *)newMessageLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    return label;
}

- (UIButton *)newAcceptButton {
    UIButton *button = [UIButton new];
    button.backgroundColor = kTHLNUIActionColor;
    [button setTitleColor:[UIColor whiteColor]];
    return button;
}
- (UIButton *)newDeclineButton {
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor clearColor];
    [button.layer setBorderWidth:0.5];
    [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [button setTitleColor:[UIColor whiteColor]];
    return button;
}

- (UIButton *)newDismissButton {
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:@"Cancel X Icon"] forState:UIControlStateNormal];
    return button;
}

- (UIActivityIndicatorView *)newActivityView {
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    return activityView;
}

@end
