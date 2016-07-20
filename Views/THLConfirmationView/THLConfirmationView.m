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


@property (nonatomic, strong) UIImageView *checkIconView;
@property (nonatomic, strong) UIView *underlineView;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end


@implementation THLConfirmationView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        self.tintColor = [UIColor blackColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.autoresizesSubviews = YES;
        
        [self.underlineView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.centerY.offset(-75);
            make.size.equalTo(CGSizeMake(SCREEN_WIDTH*0.33f, kTHLRedeemPerkViewSeparatorViewHeight));
        }];
        
        WEAKSELF();
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(WSELF.underlineView.mas_top).insets(kTHLEdgeInsetsSuperHigh());
            make.centerX.offset(0);
            make.left.right.insets(kTHLEdgeInsetsNone());
        }];
        
        [self.messageLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(WSELF.underlineView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.centerX.offset(0);
            make.width.equalTo(SCREEN_WIDTH*0.66);
        }];
        
        [self.acceptButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF messageLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.equalTo([WSELF mas_centerX]).insets(kTHLEdgeInsetsHigh());
            make.width.equalTo([WSELF declineButton].mas_width);
            make.height.equalTo([WSELF declineButton].mas_height);
        }];
        
        [self.declineButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF messageLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.right.equalTo([WSELF mas_centerX]).insets(kTHLEdgeInsetsHigh());
            make.width.equalTo(125);
            make.height.equalTo(kTHLConfirmationViewButtonHeight);
        }];
        
        
        [self.dismissButton makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.insets(kTHLEdgeInsetsInsanelyHigh());
            make.centerX.equalTo(0);
        }];
    }
    return self;
}

- (void)setInProgressWithMessage:(NSString *)messageText {
    self.messageLabel.text = messageText;
    [self layoutPendingView];
}

- (void)setSuccessWithTitle:(NSString *)titleText Message:(NSString *)messageText {
    self.titleLabel.text = titleText;
    self.messageLabel.text = messageText;
    [self layoutSuccessView];
}

- (void)presentView {
    // Prepare by adding to the top window.
//    if(!self.superview){
//        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
//        
//        for (UIWindow *window in frontToBackWindows) {
//            if (window.windowLevel == UIWindowLevelNormal) {
//                [window addSubview:self];
//                
//                break;
//            }
//        }
//    }
    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];
    self.frame = [UIScreen mainScreen].bounds;
    [mainWindow addSubview:self];
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)layoutPendingView {
    self.dismissButton.hidden = YES;

    [UIView animateWithDuration:0.1
                     animations:^{
                         _acceptButton.frame = CGRectZero;
                         _declineButton.frame = CGRectZero;
                     } completion:^(BOOL finished) {
                         _acceptButton.hidden = YES;
                         _declineButton.hidden = YES;
                     }];
    
    WEAKSELF();
    [self.activityView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF messageLabel].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.equalTo(0);
    }];
    
    [self.activityView startAnimating];
}

- (void)layoutSuccessView {

    [UIView animateWithDuration:0.1
                     animations:^{
                         _activityView.frame = CGRectZero;
                     } completion:^(BOOL finished) {
                         _activityView.hidden = YES;
                         _dismissButton.hidden = NO;

                     }];
    
    [self.activityView stopAnimating];
    
    WEAKSELF();
    [self.checkIconView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo([WSELF titleLabel].mas_top).insets(kTHLEdgeInsetsSuperHigh());
        make.centerX.equalTo(0);
    }];
    
}


#pragma mark - Event Handlers
- (void)handleAcceptAction {
    [self.delegate confirmationViewDidAcceptAction];
}

- (void)handleDeclineAction {
    [self dismiss];
}

#pragma mark - Accessors

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = THLNUILabel(kTHLNUIRegularTitle);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }

    return _titleLabel;
}

- (UIImageView *)checkIconView {
    if (!_checkIconView) {
        _checkIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Clear Check"]];
        _checkIconView.clipsToBounds = YES;
        _checkIconView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_checkIconView];
    }

    return _checkIconView;
}

- (UIView *)underlineView {
    if (!_underlineView) {
        _underlineView = THLNUIView(kTHLNUIUndef);
        _underlineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_underlineView];
    }

    return _underlineView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = THLNUILabel(kTHLNUIDetailTitle);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        [self addSubview:_messageLabel];
    }

    return _messageLabel;
}

- (UIButton *)acceptButton {
    if (!_acceptButton) {
        _acceptButton = [UIButton new];
        _acceptButton.backgroundColor = kTHLNUIAccentColor;
        [_acceptButton setTitle:@"YES" forState:UIControlStateNormal];
        [_acceptButton setTitleColor:[UIColor blackColor]];
        [_acceptButton addTarget:self action:@selector(handleAcceptAction) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_acceptButton];
    }

    return _acceptButton;
}
- (UIButton *)declineButton {
    if (!_declineButton) {
        _declineButton = [UIButton new];
        _declineButton.backgroundColor = [UIColor clearColor];
        [_declineButton.layer setBorderWidth:0.5];
        [_declineButton setTitle:@"NO" forState:UIControlStateNormal];
        
        [_declineButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [_declineButton setTitleColor:[UIColor whiteColor]];
        [_declineButton addTarget:self action:@selector(handleDeclineAction) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_declineButton];
    }

    return _declineButton;
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton new];
        [_dismissButton setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dismissButton];
    }

    return _dismissButton;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_activityView];
    }

    return _activityView;
}

@end
