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
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIView *separatorView;
@end

@implementation THLPromotionInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _typeLabel = [self newTypeLabel];
    _textLabel = [self newTextLabel];
}

- (void)layoutView {
    [self addSubviews:@[_typeLabel, _textLabel]];
    WEAKSELF();
    [_typeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.insets(kTHLEdgeInsetsNone());
        make.left.insets(kTHLEdgeInsetsNone());
        make.right.equalTo([WSELF textLabel].mas_left).insets(kTHLEdgeInsetsNone());
        make.width.equalTo(WSELF.textLabel);
    }];
    
    [_textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.insets(kTHLEdgeInsetsNone());
        make.left.equalTo([WSELF typeLabel].mas_right).insets(kTHLEdgeInsetsNone());
    }];
}

- (void)bindView {
    RAC(self.typeLabel, text) = RACObserve(self, labelText);
    RAC(self.textLabel, text) = RACObserve(self, infoText);
}

#pragma mark - Constructors
- (UILabel *)newTypeLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    return label;
}

- (UILabel *)newTextLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 0;
    return label;
}

- (UIView *)newSeparatorView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.alpha = 0.7;
    return view;
}
@end
