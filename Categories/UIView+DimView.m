//
//  UIView+DimViews.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import <objc/runtime.h>
#import "THLAppearanceConstants.h"
#import "UIView+DimView.h"
#import "Masonry.h"

static void *DimmingViewPropertyKey = &DimmingViewPropertyKey;

@implementation UIView (DimViews)

- (void)dimView {
    UIView *dimmingView = [UIView new];
    dimmingView.backgroundColor = [UIColor blackColor];
    dimmingView.alpha = 0.5;
    [self addSubview:dimmingView];
    [dimmingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)undimView {
    [self.dimmingView removeFromSuperview];
    self.dimmingView = nil;
}

- (UIView *)dimmingView {
    return objc_getAssociatedObject(self, DimmingViewPropertyKey);
}

- (void)setDimmingView:(UIView *)dimmingView {
    objc_setAssociatedObject(self, DimmingViewPropertyKey, dimmingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end