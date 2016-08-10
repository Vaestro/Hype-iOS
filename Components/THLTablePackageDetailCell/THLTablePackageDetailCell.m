//
//  THLTablePackageDetailCell.m
//  Hype
//
//  Created by Daniel Aksenov on 6/5/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTablePackageDetailCell.h"
#import "THLAppearanceConstants.h"
#import <ParseUI/PFImageView.h>
#import "UIView+DimView.h"

@interface THLTablePackageDetailCell()
@property (nonatomic, strong) UIView *amountView;
@end

@implementation THLTablePackageDetailCell
@synthesize titleLabel = _titleLabel;
@synthesize amountLabel = _amountLabel;

- (void)layoutSubviews
{
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.cornerRadius = 5.0;
    
    self.contentView.layer.borderColor = [kTHLNUIAccentColor CGColor];
    
    WEAKSELF();

    [_amountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.bottom.equalTo(WSELF.mas_centerY);
    }];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(WSELF.mas_centerY);
        make.left.right.insets(kTHLEdgeInsetsSuperHigh());
    }];
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = THLNUILabel(kTHLNUIDetailBoldTitle);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = TRUE;
        _titleLabel.minimumScaleFactor = 0.5;
        _titleLabel.numberOfLines = 3;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)amountLabel
{
    if (!_amountLabel) {
        _amountLabel = [UILabel new];
        _amountLabel.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        _amountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:36];
        _amountLabel.textColor = kTHLNUIAccentColor;
        [self.contentView addSubview:_amountLabel];
    }
    return _amountLabel;
}

#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end

