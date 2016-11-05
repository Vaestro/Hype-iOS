    //
//  THLPersonIconView.m
//  Hypelist2point0
//
//  Created by Edgar Li on 11/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPersonIconView.h"
#import "THLAppearanceConstants.h"
#import "UIImageView+Letters.h"

@interface THLPersonIconView()
@property (nonatomic, strong) UILabel *unregisteredUserTextLabel;
@end

@implementation THLPersonIconView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setPlaceholderImageText:(NSString *)placeholderImageText {
    if (placeholderImageText > 0) {
        [self.imageView setImageWithString:placeholderImageText
                                     color:kTHLNUIPrimaryBackgroundColor];
        [[self.imageView layer] setBorderWidth:1.0f];
        [[self.imageView layer] setBorderColor:kTHLNUIGrayFontColor.CGColor];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.layer.cornerRadius = ViewWidth(self.imageView)/2.0;
}

- (PFImageView *)imageView {
    if (!_imageView) {
        _imageView = [PFImageView new];
        _imageView.clipsToBounds = YES;
        _imageView.tintColor = kTHLNUIPrimaryBackgroundColor;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        [self addSubview:_imageView];
    }

    return _imageView;
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
        self.imageView.image = image;
    } else {
        self.imageView.image = [self placeHolderImage];
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
    return self.imageView.image;
}

- (UIImage *)placeHolderImage {
    UIImage *image = [[UIImage imageNamed:@"default_profile_image"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}

@end
