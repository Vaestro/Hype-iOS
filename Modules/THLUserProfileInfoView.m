//
//  THLUserProfileInfoView.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/11/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserProfileInfoView.h"
#import "THLPersonIconView.h"
#import "THLAppearanceConstants.h"


@interface THLUserProfileInfoView()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) THLPersonIconView *iconView;

@end

@implementation THLUserProfileInfoView

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
    self.backgroundColor = kTHLNUISecondaryBackgroundColor;
    _iconView = [self newIconView];
    _label = [self newLabel];
    
}

- (void)layoutView {
    [self addSubviews:@[_iconView,
                        _label]];
    WEAKSELF();
    [_iconView makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsSuperHigh()).priorityHigh();
        make.left.top.greaterThanOrEqualTo(SV(_iconView)).insets(kTHLEdgeInsetsHigh());
        make.right.lessThanOrEqualTo(SV(WSELF.iconView)).insets(kTHLEdgeInsetsHigh());
        make.height.equalTo([WSELF iconView].mas_width);
        make.centerX.equalTo(0);
    }];
    
    [_label makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconView.mas_bottom).insets(kTHLEdgeInsetsSuperHigh());
        make.bottom.left.right.insets(kTHLEdgeInsetsHigh());
        make.centerX.equalTo(_iconView.mas_centerX);
    }];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)bindView {
    RAC(self.iconView, imageURL) = RACObserve(self, userImageURL);
    RAC(self.label, text) = RACObserve(self, userName);
}

#pragma mark - Construtors
- (THLPersonIconView *)newIconView {
    THLPersonIconView *iconView = [THLPersonIconView new];
    return iconView;
}

- (UILabel *)newLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
