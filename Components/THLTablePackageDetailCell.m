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
@synthesize amountLabel = _amountLabel;


- (void)layoutSubviews
{
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(0);
        make.left.insets(kTHLEdgeInsetsNone());
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

