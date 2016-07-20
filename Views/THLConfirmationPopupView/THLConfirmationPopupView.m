//
//  THLConfirmationPopupView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/5/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLConfirmationPopupView.h"
#import "THLAppearanceConstants.h"

@interface THLConfirmationPopupView()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *dismissButton;
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
    _acceptButton = [self newAcceptButton];
    _declineButton = [self newDeclineButton];
    _dismissButton = [self newDismissButton];
}

- (void)layoutView {
    [self addSubviews:@[_textView,
                        _acceptButton,
                        _declineButton,
                        _dismissButton]];
    
    WEAKSELF();
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
        [_acceptButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF textView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.right.insets(UIEdgeInsetsZero).insets(kTHLEdgeInsetsSuperHigh());
            make.width.equalTo(ScreenWidth*0.67);
        }];
    
        [_declineButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF acceptButton].mas_bottom).insets(kTHLEdgeInsetsHigh());
            make.right.left.insets(UIEdgeInsetsZero).insets(kTHLEdgeInsetsSuperHigh());
            make.width.equalTo(_acceptButton.mas_width);
        }];
    
        [_dismissButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.lessThanOrEqualTo([WSELF declineButton].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
            make.left.right.insets(kTHLEdgeInsetsSuperHigh());
            make.bottom.equalTo(SV(WSELF.dismissButton).mas_bottom);
            make.centerX.offset(0);
        }];
    /**
     *  Side By Side Layout
     */
    
//    [_acceptButton makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo([WSELF textView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
//        make.bottom.left.insets(UIEdgeInsetsZero).insets(kTHLEdgeInsetsHigh());
//        make.right.equalTo([WSELF declineButton].mas_left).insets(kTHLEdgeInsetsHigh());
//        make.width.equalTo(WSELF.declineButton);
//    }];
//    
//    [_declineButton makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo([WSELF textView].mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
//        make.right.bottom.insets(UIEdgeInsetsZero).insets(kTHLEdgeInsetsHigh());
//    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)bindView {
    WEAKSELF();
//    RAC(self.textView, text) = RACObserve(WSELF, confirmationText);
//    RAC(self.acceptButton, rac_command) = RACObserve(WSELF, acceptCommand);
//    [[self.acceptButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [WSELF dismissPresentingPopup];
//    }];
//    RAC(self.declineButton, rac_command) = RACObserve(WSELF, declineCommand);
//    [[self.declineButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [WSELF dismissPresentingPopup];
//    }];
//    
//    [[self.dismissButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [WSELF dismissPresentingPopup];
//    }];
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

- (THLActionButton *)newAcceptButton {
    THLActionButton *acceptButton = [THLActionButton new];
    acceptButton.backgroundColor = kTHLNUIActionColor;
    return acceptButton;
}

- (THLActionButton *)newDeclineButton {
    THLActionButton *declineButton = [THLActionButton new];
    declineButton.backgroundColor = kTHLNUIRedColor;
    
    return declineButton;
}

- (UIButton *)newDismissButton {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(33, 33, 33, 33)];
    [button setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
    return button;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end