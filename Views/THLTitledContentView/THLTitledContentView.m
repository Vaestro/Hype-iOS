//
//  THLTitledContentView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLTitledContentView.h"
#import "THLAppearanceConstants.h"

@interface THLTitledContentView()
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation THLTitledContentView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _titleLabel = [self newTitleLabel];
    _contentView = [self newContentView];
    _separatorView = [self newSeparatorView];

}

- (void)layoutView {
    [self addSubviews:@[_titleLabel,
                        _contentView,
                        _separatorView]];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    WEAKSELF();
    [_separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF titleLabel].mas_baseline).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF titleLabel]);
        make.size.equalTo(CGSizeMake(40, 2.5));
    }];
    
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF separatorView].mas_bottom);
        make.left.right.equalTo([WSELF titleLabel]);
        make.bottom.left.right.insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    RAC(self.titleLabel, text) = RACObserve(self, title);
    RAC(self.titleLabel, textColor) = RACObserve(self, titleColor);
}

#pragma mark - Constructors
- (UIView *)newContentView {
    UIView *view = [UIView new];
    return view;
}

- (UILabel *)newTitleLabel {
    UILabel *label = THLNUILabel(kTHLNUISectionTitle);
    label.alpha = 0.7;
    return label;
}

- (UIView *)newSeparatorView {
    UIView *view = THLNUIView(kTHLNUIUndef);
    view.backgroundColor = kTHLNUIAccentColor;
    return view;
}

@end
