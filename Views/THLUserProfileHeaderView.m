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
#import "THLUser.h"

@interface THLUserProfileHeaderView()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) THLPersonIconView *iconView;

@end

@implementation THLUserProfileHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
//        self.label = [self newLabel];
//        self.imageView = [self newImageView];
//        self.photoTapRecognizer = [self tapGestureRecognizer];
        
        [self.contentView setBackgroundColor:kTHLNUIPrimaryBackgroundColor];
//        [self.iconView addGestureRecognizer:_photoTapRecognizer];
        
        [self.iconView makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.insets(kTHLEdgeInsetsHigh());
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.centerX.equalTo(0);
        }];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([super sizeThatFits:size].width, 100);
}

#pragma mark - Construtors
- (THLPersonIconView *)iconView {
    if (!_iconView) {
        _iconView = [THLPersonIconView new];
        if ([THLUser currentUser].image) {
            PFFile *imageFile = [THLUser currentUser].image;
            NSURL *url = [NSURL URLWithString:imageFile.url];
            [_iconView.imageView sd_setImageWithURL:url];
        } else {
            [_iconView setImage:nil];
        }
        [self.contentView
         addSubview:_iconView];
    }

    return _iconView;
}

- (UILabel *)nameLabel {
    UILabel *label = THLNUILabel(kTHLNUIRegularTitle);
    [label setTextColor:kTHLNUIPrimaryFontColor];
//    label.text = [THLUser currentUser].fullName;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"user_profile_cover"];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
    }

    return _imageView;
}

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

- (UITapGestureRecognizer *) tapGestureRecognizer{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    return tapRecognizer;
}

@end
