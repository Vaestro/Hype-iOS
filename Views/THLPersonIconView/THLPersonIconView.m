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
    WEAKSELF();
    [[RACObserve(self, imageURL) filter:^BOOL(NSURL *url) {
        return [url isValid];
    }] subscribeNext:^(NSURL *url) {
        [WSELF.imageView sd_setImageWithURL:url];
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
    imageView.backgroundColor = kTHLNUIPrimaryBackgroundColor;
    imageView.image = [self placeHolderImage];

//    FBTweakBind(imageView.layer, borderWidth, kTHLFBTweaksCategoryMainKey, kTHLFBTweaksGroupGuestListInvitationPopup, @"Border Radius", 1.0, 0.0, 5.0);
    return imageView;
}

//- (void)setPerson:(id<THLPerson>)person {
//    _person = person;
//    _imageView.image = [self placeHolderImage];
//    [[person thumbnail] downloadAndSetImageInBackground:_imageView];
//}

- (void)setImage:(UIImage *)image {
    if (image) {
        _imageView.image = image;
    } else {
        image = [self placeHolderImage];
    }
}

- (UIImage *)image {
    return _imageView.image;
}

- (UIImage *)placeHolderImage {
    UIImage *image = [[UIImage imageNamed:@"Hypelist-Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}
//- (UIImage *)placeHolderImage {
//    // adjust bounds to account for extra space needed for lineWidth
//    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
//    CGRect bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height);
//    
//    // create a view to draw the path in
//    UIView *view = [[UIView alloc] initWithFrame:bounds];
//    
//    // begin graphics context for drawing
//    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [[UIScreen mainScreen] scale]);
//    
//    // configure the view to render in the graphics context
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    // get reference to the graphics context
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // translate matrix so that path will be centered in bounds
//    CGContextTranslateCTM(context, -(bounds.origin.x), -(bounds.origin.y));
//    
//    //// HypeList-Icon Drawing
//    UIBezierPath* hypeListIconPath = [UIBezierPath bezierPath];
//    [hypeListIconPath moveToPoint: CGPointMake(24.64, 45.43)];
//    [hypeListIconPath addLineToPoint: CGPointMake(18.29, 72.62)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(16.91, 73.47) controlPoint1: CGPointMake(18.15, 73.23) controlPoint2: CGPointMake(17.53, 73.62)];
//    [hypeListIconPath addLineToPoint: CGPointMake(6.79, 71.17)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(5.93, 69.8) controlPoint1: CGPointMake(6.17, 71.02) controlPoint2: CGPointMake(5.78, 70.41)];
//    [hypeListIconPath addLineToPoint: CGPointMake(19.14, 13.2)];
//    [hypeListIconPath addLineToPoint: CGPointMake(4.72, 18.68)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(3.23, 18.02) controlPoint1: CGPointMake(4.13, 18.9) controlPoint2: CGPointMake(3.46, 18.61)];
//    [hypeListIconPath addLineToPoint: CGPointMake(0.08, 9.9)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(0.74, 8.43) controlPoint1: CGPointMake(-0.15, 9.31) controlPoint2: CGPointMake(0.14, 8.65)];
//    [hypeListIconPath addLineToPoint: CGPointMake(22.64, 0.11)];
//    [hypeListIconPath addLineToPoint: CGPointMake(22.64, 0.11)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(23.4, 0.03) controlPoint1: CGPointMake(22.87, 0) controlPoint2: CGPointMake(23.13, -0.03)];
//    [hypeListIconPath addLineToPoint: CGPointMake(33.52, 2.34)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(34.38, 3.71) controlPoint1: CGPointMake(34.14, 2.48) controlPoint2: CGPointMake(34.52, 3.09)];
//    [hypeListIconPath addLineToPoint: CGPointMake(27.56, 32.92)];
//    [hypeListIconPath addLineToPoint: CGPointMake(48.31, 32.92)];
//    [hypeListIconPath addLineToPoint: CGPointMake(55.67, 1.38)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(57.06, 0.53) controlPoint1: CGPointMake(55.82, 0.77) controlPoint2: CGPointMake(56.44, 0.38)];
//    [hypeListIconPath addLineToPoint: CGPointMake(67.17, 2.83)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(68.04, 4.2) controlPoint1: CGPointMake(67.79, 2.98) controlPoint2: CGPointMake(68.18, 3.59)];
//    [hypeListIconPath addLineToPoint: CGPointMake(54.82, 60.83)];
//    [hypeListIconPath addLineToPoint: CGPointMake(69.28, 55.34)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(70.77, 55.99) controlPoint1: CGPointMake(69.87, 55.11) controlPoint2: CGPointMake(70.54, 55.41)];
//    [hypeListIconPath addLineToPoint: CGPointMake(73.92, 64.11)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(73.26, 65.59) controlPoint1: CGPointMake(74.15, 64.7) controlPoint2: CGPointMake(73.86, 65.36)];
//    [hypeListIconPath addLineToPoint: CGPointMake(51.32, 73.92)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(50.99, 73.99) controlPoint1: CGPointMake(51.21, 73.96) controlPoint2: CGPointMake(51.1, 73.98)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(50.57, 73.97) controlPoint1: CGPointMake(50.85, 74.01) controlPoint2: CGPointMake(50.71, 74)];
//    [hypeListIconPath addLineToPoint: CGPointMake(40.45, 71.66)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(39.59, 70.29) controlPoint1: CGPointMake(39.83, 71.52) controlPoint2: CGPointMake(39.44, 70.91)];
//    [hypeListIconPath addLineToPoint: CGPointMake(45.38, 45.46)];
//    [hypeListIconPath addLineToPoint: CGPointMake(24.9, 45.46)];
//    [hypeListIconPath addCurveToPoint: CGPointMake(24.64, 45.43) controlPoint1: CGPointMake(24.81, 45.46) controlPoint2: CGPointMake(24.72, 45.45)];
//    [hypeListIconPath addLineToPoint: CGPointMake(24.64, 45.43)];
//    [hypeListIconPath closePath];
//    hypeListIconPath.miterLimit = 4;
//    
//    hypeListIconPath.usesEvenOddFillRule = YES;
//    
//    [kTHLNUIPrimaryFontColor setFill];
//    [hypeListIconPath fill];
//    
//    // get an image of the graphics context
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // end the context
//    UIGraphicsEndImageContext();
//    
//    return viewImage;
//}
@end
