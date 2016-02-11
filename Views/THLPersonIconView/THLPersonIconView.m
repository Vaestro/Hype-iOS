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
@property (nonatomic, strong) UILabel *unregisteredUserTextLabel;
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
    @weakify(self);
    [[RACObserve(self, imageURL) filter:^BOOL(NSURL *url) {
        return [url isValid];
    }] subscribeNext:^(NSURL *url) {
        @strongify(self)
        [self.imageView sd_setImageWithURL:url];
    }];
    
    [RACObserve(self, placeholderImageText) subscribeNext:^(NSString *text) {
        @strongify(self)
        [self.imageView setImageWithString:text
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
    imageView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    return imageView;
}

- (UILabel *)newUnregisteredUserTextLabel {
    UILabel *label = THLNUILabel(kTHLNUIDetailTitle);
    label.text = @"Unregistered User";
    [label setTextColor:kTHLNUIAccentColor];
    label.adjustsFontSizeToFitWidth = YES;
    return label;
}

- (void)setImage:(UIImage *)image {
    if (image != nil) {
    _imageView.image = image;
    } else {
        _imageView.image = [self placeHolderImage];
//        [self setUnregisteredUserOn];
    }
}

- (void)setUnregisteredUserOn {
    [self addSubview:_unregisteredUserTextLabel];
    [_unregisteredUserTextLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.top.bottom.right.left.insets(kTHLEdgeInsetsNone());
    }];
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
