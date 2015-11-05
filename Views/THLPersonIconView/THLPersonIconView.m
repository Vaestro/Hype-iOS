//
//  THLPersonIconView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPersonIconView.h"
//#import "ParseUI.h"
#import "THLAppearanceConstants.h"

@interface THLPersonIconView()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation THLPersonIconView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self constructView];
        [self layoutView];
        [self bindView];
    }
    return self;
}

- (void)constructView {
    _imageView = [self newImageView];
}

- (void)layoutView {
    [self addSubview:_imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    _imageView.layer.cornerRadius = ViewWidth(_imageView)/2.0;
}

- (void)bindView {
    [[RACObserve(self, imageURL) filter:^BOOL(NSURL *url) {
        return [url isValid];
    }] subscribeNext:^(NSURL *url) {
        [self.imageView sd_setImageWithURL:url];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.layer.cornerRadius = ViewWidth(_imageView)/2.0;
}

- (UIImageView *)newImageView {
    UIImageView *imageView = [UIImageView new];
    imageView.clipsToBounds = YES;
    imageView.tintColor = kTHLNUIPrimaryBackgroundColor;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.borderColor = kTHLNUIGrayFontColor.CGColor;
    imageView.layer.borderWidth = 0.5;
    imageView.image = [self placeHolderImage];
//    FBTweakBind(imageView.layer, borderWidth, kTHLFBTweaksCategoryMainKey, kTHLFBTweaksGroupGuestListInvitationPopup, @"Border Radius", 1.0, 0.0, 5.0);
    return imageView;
}

//- (void)setPerson:(id<THLPerson>)person {
//    _person = person;
//    _imageView.image = [self placeHolderImage];
//    [[person thumbnail] downloadAndSetImageInBackground:_imageView];
//}

//- (void)setImage:(UIImage *)image {
//    if (image) {
//        _imageView.image = image;
//    } else {
//        image = [self placeHolderImage];
//    }
//}
//
//- (UIImage *)image {
//    return _imageView.image;
//}

- (UIImage *)placeHolderImage {
    UIImage *image = [[UIImage imageNamed:@"HypeList Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    return image;
}
@end
