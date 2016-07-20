//
//  THLContactTableViewCell.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLContactTableViewCell.h"
#import "THLAppearanceConstants.h"

@interface THLContactTableViewCell()

@end

@implementation THLContactTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAKSELF();
        
        [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.insets(kTHLEdgeInsetsHigh());
            make.width.equalTo([WSELF iconImageView].mas_height);
        }];
        
        [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.insets(kTHLEdgeInsetsHigh());
            make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
        }];
        
        [self.phoneNumberLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo([WSELF nameLabel].mas_baseline).insets(kTHLEdgeInsetsHigh());
            make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
            make.bottom.right.insets(kTHLEdgeInsetsHigh());
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.layer.cornerRadius = ViewWidth(_iconImageView)/2.0;
}

#pragma mark - Constructors
- (THLPersonIconView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [THLPersonIconView new];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = THLNUILabel(kTHLNUIDetailTitle);
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)phoneNumberLabel {
    if (!_phoneNumberLabel) {
        _phoneNumberLabel = THLNUILabel(kTHLNUIDetailTitle);
        [self.contentView addSubview:_phoneNumberLabel];
    }
    return _phoneNumberLabel;
}


#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

@end
