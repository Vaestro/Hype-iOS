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
@property (nonatomic, strong) UIImageView *iconImageView;
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
    [self addSubviews:@[_iconImageView, _nameLabel, _phoneNumberLabel]];

    [_iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.insets(kTHLEdgeInsetsHigh());
        make.width.equalTo(_iconImageView.mas_height);
    }];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(_iconImageView.mas_right).insets(kTHLEdgeInsetsHigh());
    }];
    
    [_phoneNumberLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_baseline).insets(kTHLEdgeInsetsHigh());
        make.left.equalTo(_iconImageView.mas_right).insets(kTHLEdgeInsetsHigh());
        make.bottom.right.insets(kTHLEdgeInsetsHigh());
    }];
}

- (void)bindView {
    [RACObserve(self, thumbnail) subscribeNext:^(id x) {
        [_iconImageView setImage:(UIImage *)x];
    }];
    
    RAC(self.nameLabel, text) = RACObserve(self, name);
    RAC(self.phoneNumberLabel, text) = RACObserve(self, phoneNumber);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.layer.cornerRadius = ViewWidth(_iconImageView)/2.0;
}

#pragma mark - Constructors
- (UIImageView *)newIconImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.tintColor = kTHLNUIPrimaryBackgroundColor;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.borderColor = kTHLNUIGrayFontColor.CGColor;
    imageView.layer.borderWidth = 0.5;
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
@end
