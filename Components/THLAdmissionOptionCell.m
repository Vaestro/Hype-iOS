//
//  THLAdmissionOptionCell.m
//  Hype
//
//  Created by Daniel Aksenov on 6/2/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLAdmissionOptionCell.h"
#import "THLAppearanceConstants.h"


@interface THLAdmissionOptionCell()
@property (nonatomic, strong) UIImageView *iconView;
@end


@implementation THLAdmissionOptionCell
@synthesize titleLabel = _titleLabel;
@synthesize priceLabel = _priceLabel;


- (void)layoutSubviews
{
    WEAKSELF();
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.right.insets(kTHLEdgeInsetsNone());
        make.centerY.equalTo(0);
    }];
    
    [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.right.equalTo([WSELF iconView].mas_left).insets(kTHLEdgeInsetsLow());
    }];
    
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        _titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        _priceLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        _priceLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UIImageView *)iconView
{
    if (!_iconView){
        _iconView = [[UIImageView alloc]
                     initWithImage:[UIImage imageNamed:@"cell_disclosure_icon"]];
        [self.contentView addSubview:_iconView];
    }
    return _iconView;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end
