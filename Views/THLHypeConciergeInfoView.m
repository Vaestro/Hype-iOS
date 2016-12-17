//
//  THLHypeConciergeInfoView.m
//  Hype
//
//  Created by Edgar Li on 8/12/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLHypeConciergeInfoView.h"
#import "THLActionButton.h"
#import "THLAppearanceConstants.h"
#import "TTTAttributedLabel.h"


@interface THLHypeConciergeInfoView()
@property (nonatomic, strong) TTTAttributedLabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@property (nonatomic, strong) UILabel *firstMessageLabel;
@property (nonatomic, strong) UILabel *secondMessageLabel;
@property (nonatomic, strong) UILabel *thirdMessageLabel;
@property (nonatomic, strong) THLActionButton *button;
@end

@implementation THLHypeConciergeInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kTHLNUISecondaryBackgroundColor;
        self.layer.borderWidth = 1.0;
        
        self.layer.borderColor = [kTHLNUISecondaryBackgroundColor CGColor];
        
        WEAKSELF();
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.insets(kTHLEdgeInsetsSuperHigh());
            make.left.right.insets(kTHLEdgeInsetsHigh());
            make.width.equalTo(ScreenWidth-4*kTHLInset);
        }];
        
        [self.subtitleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF titleLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
            make.left.right.insets(kTHLEdgeInsetsHigh());
            make.width.equalTo(ScreenWidth-4*kTHLInset);
        }];
        
        [self.firstMessageLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF subtitleLabel].mas_bottom).insets(kTHLEdgeInsetsInsanelyHigh());
            make.left.right.insets(kTHLEdgeInsetsHigh());
            make.width.equalTo(ScreenWidth-4*kTHLInset);
        }];
        
        UIView *separatorView = THLNUIView(kTHLNUIUndef);
        separatorView.backgroundColor = kTHLNUIAccentColor;
        [self addSubview:separatorView];
        [separatorView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF firstMessageLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
            make.centerX.equalTo(WSELF);
            make.size.equalTo(CGSizeMake(30, 2.5));
        }];
        
        [self.secondMessageLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(separatorView.mas_bottom).insets(kTHLEdgeInsetsHigh());
            make.left.right.insets(kTHLEdgeInsetsHigh());
            make.width.equalTo(ScreenWidth-4*kTHLInset);
        }];
        
        UIView *secondSeparatorView = THLNUIView(kTHLNUIUndef);
        secondSeparatorView.backgroundColor = kTHLNUIAccentColor;
        [self addSubview:secondSeparatorView];
        
        [secondSeparatorView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF secondMessageLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
            make.centerX.equalTo(WSELF);
            make.size.equalTo(CGSizeMake(30, 2.5));
        }];
        
        [self.thirdMessageLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(secondSeparatorView.mas_bottom).insets(kTHLEdgeInsetsHigh());
            make.left.right.insets(kTHLEdgeInsetsHigh());
            make.width.equalTo(ScreenWidth-4*kTHLInset);
        }];
        
        [self.button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF thirdMessageLabel].mas_bottom).insets(kTHLEdgeInsetsInsanelyHigh());
            make.left.right.bottom.insets(kTHLEdgeInsetsHigh());
        }];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)continueButtonTapped {
//    [Intercom presentMessageComposer];
}

#pragma mark - Constructors

- (TTTAttributedLabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [TTTAttributedLabel new];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"HYPE CONCIERGE"
                                                                        attributes:@{
                                                                                     (id)kCTForegroundColorAttributeName : (id)[UIColor whiteColor].CGColor,
                                                                                     NSFontAttributeName : [UIFont systemFontOfSize:20],
                                                                                     NSKernAttributeName : @4.5f
                                                                                     }];
        _titleLabel.text = attString;
        
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = THLNUILabel(kTHLNUISectionTitle);
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.text = @"LET US HELP YOU PLAN THE PERFECT PARTY";
        [self addSubview:_subtitleLabel];
    }
    
    return _subtitleLabel;
}

- (UILabel *)firstMessageLabel {
    if (!_firstMessageLabel) {
        _firstMessageLabel = [UILabel new];
        _firstMessageLabel.font = [UIFont fontWithName:@"Raleway-Light" size:14.0f];
        _firstMessageLabel.textColor = kTHLNUIGrayFontColor;
        _firstMessageLabel.textAlignment = NSTextAlignmentCenter;
        _firstMessageLabel.numberOfLines = 0;
        _firstMessageLabel.text = @"Access to any and every club in the city";
        [self addSubview:_firstMessageLabel];
    }
    
    return _firstMessageLabel;
}

- (UILabel *)secondMessageLabel {
    if (!_secondMessageLabel) {
        _secondMessageLabel = [UILabel new];
        _secondMessageLabel.font = [UIFont fontWithName:@"Raleway-Light" size:14.0f];
        _secondMessageLabel.textColor = kTHLNUIGrayFontColor;

        _secondMessageLabel.textAlignment = NSTextAlignmentCenter;
        _secondMessageLabel.numberOfLines = 0;
        _secondMessageLabel.text = @"All special occasions: birthday, holiday, or bachelorette parties and more";

        [self addSubview:_secondMessageLabel];
    }
    
    return _secondMessageLabel;
}

- (UILabel *)thirdMessageLabel {
    if (!_thirdMessageLabel) {
        _thirdMessageLabel = [UILabel new];
        _thirdMessageLabel.font = [UIFont fontWithName:@"Raleway-Light" size:14.0f];
        _thirdMessageLabel.textColor = kTHLNUIGrayFontColor;

        _thirdMessageLabel.textAlignment = NSTextAlignmentCenter;
        _thirdMessageLabel.numberOfLines = 0;
        _thirdMessageLabel.text = @"Tell us your party size, budget, and desired night and let our nightlife experts find the best options for you";
        [self addSubview:_thirdMessageLabel];
    }
    
    return _thirdMessageLabel;
}

- (THLActionButton *)button {
    if (!_button) {
        _button = [[THLActionButton alloc] initWithDefaultStyle];
        [_button setTitle:@"CONTINUE"];
        [_button addTarget:self action:@selector(continueButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return _button;
}
@end
