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
#import "UIImageView+Letters.h"

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
    WEAKSELF();
    [[RACObserve(self, imageURL) filter:^BOOL(NSURL *url) {
        return [url isValid];
    }] subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
    }];
    
    [RACObserve(self, placeholderImageText) subscribeNext:^(id x) {
        [WSELF.imageView setImageWithString:WSELF.placeholderImageText
                                      color:kTHLNUIPrimaryBackgroundColor];
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
//    imageView.layer.borderColor = kTHLNUIGrayFontColor.CGColor;
//    imageView.layer.borderWidth = 0.5;
    imageView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
//    imageView.image = [self placeHolderImage];
    return imageView;
}

- (void)setImage:(UIImage *)image {
    if (image != nil) {
    _imageView.image = image;
    } else {
        image = [self placeHolderImage];
    }
}

- (UIImage *)image {
    return _imageView.image;
}

- (UIImage *)placeHolderImage {
    UIImage *image = [[UIImage imageNamed:@"Profile Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}

@end
