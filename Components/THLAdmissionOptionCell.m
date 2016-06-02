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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *iconView;
@end


@implementation THLAdmissionOptionCell
@synthesize title;
@synthesize price;


- (void)layoutSubviews
{
    WEAKSELF();
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.insets(UIEdgeInsetsZero);
    }];
    
    [_iconView makeConstraints:^(MASConstraintMaker *make) {
        make.right.insets(UIEdgeInsetsZero);
        make.centerY.equalTo(0);
    }];
    
    [_priceLabel makeConstraints:^(MASConstraintMaker *make) {
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
        _priceLabel.text = [NSString stringWithFormat:@"%@", title];
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
        _priceLabel.text = [NSString stringWithFormat:@"$ %.2f", price];
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
