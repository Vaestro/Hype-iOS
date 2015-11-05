//
//  UIView+DimViews.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import "THLAppearanceConstants.h"
#import "UIView+DimView.h"
#import "Masonry.h"

@implementation UIView (DimViews)

- (void)dimView {
    UIView *dimmingView = [UIView new];
    dimmingView.backgroundColor = [UIColor blackColor];
    //    FBTweakBind(dimmingView, alpha, kTHLFBTweaksCategoryMainKey, kTHLFBTweaksGroupGlobalKey, @"Dimming View Alpha", 0.5, 0.0, 1.0);
    dimmingView.alpha = 0.5;
    [self addSubview:dimmingView];
    [dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

//- (void)gradientDimView {
//    UIView *dimmingView = [UIView new];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = dimmingView.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
//    [dimmingView.layer insertSublayer:gradient atIndex:0];
//    [self addSubview:dimmingView];
//    [dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsZero);
//    }];
//}
@end