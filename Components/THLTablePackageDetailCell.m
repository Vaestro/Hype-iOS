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
@synthesize priceLabel = _priceLabel;
@synthesize amountLabel = _amountLabel;
@synthesize venueImageView = _venueImageView;

- (void)layoutSubviews
{
    WEAKSELF();
    [_venueImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(WSELF);
    }];
    
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
//        make.left.insets(kTHLEdgeInsetsNone());
    }];
    
    self.amountView.layer.cornerRadius = ViewWidth(_amountView)/2.0;

    [self.amountView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(kTHLEdgeInsetsSuperHigh());
        make.height.equalTo(40);
        make.width.equalTo(WSELF.amountView.mas_height);
    }];
    
    [self.amountView addSubview:self.amountLabel];

    
    [self.contentView bringSubviewToFront:_titleLabel];
    
    [self.amountLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    
//    [_amountLabel makeConstraints:^(MASConstraintMaker *make) {
//        make.right.insets(kTHLEdgeInsetsNone());
//        make.centerY.equalTo(0);
//    }];

}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = THLNUILabel(kTHLNUIDetailBoldTitle);
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}



- (UIView *)amountView
{
    if (!_amountView) {
        _amountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _amountView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        [[_amountView layer] setBorderWidth:1.0f];
        [[_amountView layer] setBorderColor:kTHLNUIAccentColor.CGColor];
        [self.contentView addSubview:_amountView];
    }
    return _amountView;
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

- (PFImageView *)venueImageView {
    if (!_venueImageView) {
        _venueImageView = [[PFImageView alloc] initWithFrame:CGRectZero];
        _venueImageView.contentMode = UIViewContentModeScaleAspectFill;
        _venueImageView.clipsToBounds = YES;
        [_venueImageView dimView];
        [self.contentView addSubview:_venueImageView];
    }
    return _venueImageView;
}


#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}
@end

