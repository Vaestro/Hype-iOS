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
}

- (void)layoutView {
    [self addSubviews:@[_titleLabel,
                        _contentView]];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.insets(kTHLEdgeInsetsNone());
    }];
    
    WEAKSELF();
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF titleLabel].mas_bottom);
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
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.7;
    return view;
}

@end
