//
//  THLTablePackageAdmissionCell.m
//  Hype
//
//  Created by Daniel Aksenov on 6/10/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLTablePackageAdmissionCell.h"
#import "THLAppearanceConstants.h"


@interface THLTablePackageAdmissionCell()
@property (nonatomic, strong) UIImageView *iconView;
@end


@implementation THLTablePackageAdmissionCell
@synthesize titleLabel = _titleLabel;
@synthesize priceLabel = _priceLabel;
@synthesize perPersonLabel = _perPersonLabel;
@synthesize partySizeLabel = _partySizeLabel;


- (void)layoutSubviews
{
    WEAKSELF();
    
    [self.partySizeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.insets(kTHLEdgeInsetsHigh());
        make.bottom.insets(kTHLEdgeInsetsLow());
    }];
    
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.right.insets(kTHLEdgeInsetsNone());
        make.width.equalTo(20);
        make.height.equalTo(WSELF.iconView.mas_width);
        make.centerY.equalTo(0);
    }];
    
    [self.priceLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.insets(kTHLEdgeInsetsLow());
        make.right.equalTo([WSELF iconView].mas_left).insets(kTHLEdgeInsetsLow());
    }];
    
    [self.perPersonLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsLow());
        make.right.equalTo([WSELF iconView].mas_left).insets(kTHLEdgeInsetsLow());
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.insets(kTHLEdgeInsetsLow());
        make.left.insets(kTHLEdgeInsetsHigh());
        make.right.equalTo([WSELF perPersonLabel].mas_left).insets(kTHLEdgeInsetsHigh());
        
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = THLNUILabel(kTHLNUIDetailBoldTitle);
        _titleLabel.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        _titleLabel.adjustsFontSizeToFitWidth = TRUE;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        _priceLabel.textColor = kTHLNUIAccentColor;
        _priceLabel.textAlignment = NSTextAlignmentRight;

        [self.contentView addSubview:_priceLabel];
    }
    return _priceLabel;
}

- (UILabel *)perPersonLabel
{
    if (!_perPersonLabel) {
        _perPersonLabel = [UILabel new];
        _perPersonLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        _perPersonLabel.textColor = [UIColor whiteColor];
        _perPersonLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_perPersonLabel];
    }
    return _perPersonLabel;
}

- (UILabel *)partySizeLabel
{
    if (!_partySizeLabel) {
        _partySizeLabel = [UILabel new];
        _partySizeLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:16];
        _partySizeLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_partySizeLabel];
    }
    return _partySizeLabel;
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
