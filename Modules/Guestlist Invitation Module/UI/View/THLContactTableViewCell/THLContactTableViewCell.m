//
//  THLContactTableViewCell.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLContactTableViewCell.h"
#import "THLAppearanceConstants.h"
#import "THLPersonIconView.h"

@interface THLContactTableViewCell()
@property (nonatomic, strong) THLPersonIconView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@end

@implementation THLContactTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _iconImageView = [self newIconImageView];
    _nameLabel = [self newNameLabel];
    _phoneNumberLabel = [self newPhoneNumberLabel];
}

- (void)layoutView {
    WEAKSELF();
    [self.contentView addSubviews:@[_iconImageView, _nameLabel, _phoneNumberLabel]];

    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.insets(kTHLEdgeInsetsHigh());
        make.width.equalTo([WSELF iconImageView].mas_height);
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_phoneNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([WSELF nameLabel].mas_baseline).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo([WSELF iconImageView].mas_right).insets(kTHLEdgeInsetsHigh());
        make.bottom.right.insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)bindView {
//    RAC(_iconImageView, image) = RACObserve(self, thumbnail);
    RAC(_iconImageView, placeholderImageText) = RACObserve(self, name);
    RAC(_nameLabel, text) = RACObserve(self, name);
    RAC(_phoneNumberLabel, text) = RACObserve(self, phoneNumber);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.layer.cornerRadius = ViewWidth(_iconImageView)/2.0;
}

#pragma mark - Constructors
- (THLPersonIconView *)newIconImageView {
    THLPersonIconView *imageView = [THLPersonIconView new];
    return imageView;
}

- (UILabel *)newNameLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    return label;
}

- (UILabel *)newPhoneNumberLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    return label;
}


#pragma mark - Public Interface
+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
