//
//  THLTablePackageDetailCell.m
//  Hype
//
//  Created by Daniel Aksenov on 6/5/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTablePackageDetailCell.h"
#import "THLAppearanceConstants.h"

@interface THLTablePackageDetailCell()
@end

@implementation THLTablePackageDetailCell
@synthesize titleLabel = _titleLabel;
@synthesize priceLabel = _priceLabel;
@synthesize amountLabel = _amountLabel;


- (void)layoutSubviews
{
    WEAKSELF();
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.insets(kTHLEdgeInsetsNone());
    }];
    
    [_priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsNone());
        make.top.equalTo([WSELF titleLabel].mas_bottom).insets(kTHLEdgeInsetsLow());
    }];
    
    [_amountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.right.insets(kTHLEdgeInsetsNone());
        make.centerY.equalTo(0);
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
        _priceLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:10];
        _priceLabel.textColor = kTHLNUIAccentColor;
        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}


- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [UILabel new];
        _amountLabel.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        _amountLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        _amountLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_amountLabel];
    }
    return _amountLabel;
}


#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end

