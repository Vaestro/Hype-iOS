//
//  THLUserProfileHeaderView.m
//  TheHypelist
//
//  Created by Edgar Li on 12/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserProfileHeaderView.h"
#import "THLPersonIconView.h"
#import "THLAppearanceConstants.h"
#import "UIView+DimView.h"
#import "THLUserManager.h"

@interface THLUserProfileHeaderView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) THLPersonIconView *iconView;

@end

@implementation THLUserProfileHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    self.contentView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    _iconView = [self newIconView];
    _label = [self newLabel];
    _imageView = [self newImageView];
    _photoTapRecognizer = [self tapGestureRecognizer];
}

- (void)layoutView {
    [self.contentView addSubviews:@[_iconView]];
    [self.contentView setBackgroundColor:kTHLNUISecondaryBackgroundColor];
    [_iconView addGestureRecognizer:_photoTapRecognizer];
    
    WEAKSELF();
    [_iconView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.insets(kTHLEdgeInsetsHigh());
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(0);
    }];
    
    if (![THLUserManager userLoggedIn]) {
        _iconView.hidden = TRUE;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)updateConstraints {
    [super updateConstraints];
}

- (void)bindView {
    RAC(self.iconView, imageURL) = RACObserve(self, userImageURL);
    RAC(self.label, text, @"") = RACObserve(self, userName);
    
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([super sizeThatFits:size].width, 100);
}

#pragma mark - Construtors
- (THLPersonIconView *)newIconView {
    THLPersonIconView *iconView = [THLPersonIconView new];
    return iconView;
}

- (UILabel *)newLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    [label setTextColor:kTHLNUIPrimaryFontColor];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"user_profile_cover"];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    return imageView;
}

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (UITapGestureRecognizer *) tapGestureRecognizer{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    return tapRecognizer;
}

@end
