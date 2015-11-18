//
//  THLGuestFlowViewController.m
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestFlowNavigationController.h"

#import "SLPagingViewController.h"
#import "THLAppearanceConstants.h"

@interface THLGuestFlowNavigationController()
@property (nonatomic, strong) UIView *discoveryNavBarItem;
@property (nonatomic, strong) UIView *guestProfileNavBarItem;
@property (nonatomic, strong) UIView *dashboardNavBarItem;
@property (nonatomic, strong) SLPagingViewController *pagingViewController;
@property (nonatomic, strong) NSArray *views;
@end

@implementation THLGuestFlowNavigationController
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController
                   leftSideViewController:(UIViewController *)leftSideViewController
                      rightSideViewController:(UIViewController *)rightSideViewController {
    if (self = [super init]) {
        _views = @[leftSideViewController.view, mainViewController.view, rightSideViewController.view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
}


- (void)constructView {
    NSArray *navBarItems = @[
                             [self newDashboardNavBarItem],
                             [self newDiscoveryNavBarItem],
                             [self newGuestProfileNavBarItem]
                             ];
    
    _pagingViewController = [[SLPagingViewController alloc] initWithNavBarItems:navBarItems
                                                                                    navBarBackground:kTHLNUIPrimaryBackgroundColor
                                                                                               views:_views
                                                                                     showPageControl:NO];
}

- (void)layoutView {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    _pagingViewController.navigationSideItemsStyle = SLNavigationSideItemsStyleOnBounds;
//    [_pagingViewController performSelector:@selector(updateNavItems:) withObject:@(0)];
    _pagingViewController.pagingViewMovingRedefine = ^(UIScrollView * scrollView, NSArray *subviews) {
        for (UIView *view in subviews) {
            CGFloat minimumOpacity = 0.3;
            //			if (view != profileNavBarView) {
            CGFloat horizontalOffset = ABS(CGRectGetMidX(view.frame) - ScreenWidth/2.0);
            CGFloat alpha;
            if (horizontalOffset == 0) {
                alpha = 1;
            } else if (horizontalOffset < 100) {
                alpha = 1 - ((1 - minimumOpacity) * horizontalOffset/100);
            } else {
                alpha = minimumOpacity;
            }
            view.tintColor = kTHLNUIGrayFontColor;
            view.alpha = alpha;
        }
    };
    [_pagingViewController setCurrentIndex:1 animated:NO];
    [self setViewControllers:@[_pagingViewController]];
}

- (UIView *)newDiscoveryNavBarItem {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Hypelist-Icon"]
                                                                 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tintColor = kTHLNUIGrayFontColor;
    return imageView;
}

- (UIView *)newGuestProfileNavBarItem {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Profile Icon"]
                                                                 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    imageView.tintColor = kTHLNUIGrayFontColor;
    return imageView;
}

- (UIView *)newDashboardNavBarItem {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Lists Icon"]
                                                                 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tintColor = kTHLNUIGrayFontColor;
    return imageView;
}
@end
