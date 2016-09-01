//
//  THLPromotionInfoLabel.m
//  TheHypelist
//
//  Created by Edgar Li on 11/13/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPromotionInfoView.h"
#import "THLAppearanceConstants.h"

@interface THLPromotionInfoView()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *dismissButton;

@end

@implementation THLPromotionInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        WEAKSELF();
        
        self.tintColor = [UIColor blackColor];
        self.blurRadius = 100.0f;
        
        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.insets(kTHLEdgeInsetsNone());
            make.bottom.equalTo([WSELF dismissButton].mas_top).insets(kTHLEdgeInsetsInsanelyHigh());
        }];
        
        [self.dismissButton makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.insets(kTHLEdgeInsetsInsanelyHigh());

            make.left.right.insets(kTHLEdgeInsetsHigh());
        }];

        [self generateContent];

    }
    return self;
}

- (void)generateContent {
    WEAKSELF();
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(WSELF.scrollView);
        make.width.equalTo(WSELF.scrollView);
    }];
    
    [contentView addSubviews:@[self.promotionTitleLabel, self.promotionDetailsLabel]];
    
    [self.promotionTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsInsanelyHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
    
    [self.promotionDetailsLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF promotionTitleLabel].mas_bottom).insets(kTHLEdgeInsetsHigh());
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());

    }];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(WSELF.promotionDetailsLabel.mas_bottom);
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
}


#pragma mark - Constructors
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)promotionTitleLabel {
    if (!_promotionTitleLabel) {
        _promotionTitleLabel = THLNUILabel(kTHLNUIDetailBoldTitle);
        _promotionTitleLabel.adjustsFontSizeToFitWidth = YES;
        _promotionTitleLabel.minimumScaleFactor = 0.5;
        _promotionTitleLabel.textAlignment = NSTextAlignmentLeft;
        _promotionTitleLabel.numberOfLines = 0;
    }
    return _promotionTitleLabel;
}

- (UILabel *)promotionDetailsLabel {
    if (!_promotionDetailsLabel) {
        _promotionDetailsLabel = THLNUILabel(kTHLNUIDetailTitle);
        _promotionDetailsLabel.adjustsFontSizeToFitWidth = YES;
        _promotionDetailsLabel.minimumScaleFactor = 0.5;
        _promotionDetailsLabel.textAlignment = NSTextAlignmentLeft;
        _promotionDetailsLabel.numberOfLines = 0;
    }
    return _promotionDetailsLabel;
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc]init];
        _dismissButton.frame = CGRectMake(0, 0, 50, 50);
        [_dismissButton setImage:[UIImage imageNamed:@"cancel_button"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dismissButton];
        
    }
    
    return _dismissButton;
}
@end
