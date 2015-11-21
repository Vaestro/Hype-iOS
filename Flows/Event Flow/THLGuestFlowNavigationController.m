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
@property (nonatomic, strong) UIViewController *profileVC;
@property (nonatomic, strong) UIViewController *discoveryVC;
@property (nonatomic, strong) UIViewController *dashboardVC;

@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) NSArray *navBarItems;
@end

@implementation THLGuestFlowNavigationController
- (instancetype)initWithMainViewController:(UIViewController *)mainViewController
                   leftSideViewController:(UIViewController *)leftSideViewController
                      rightSideViewController:(UIViewController *)rightSideViewController {
    if (self = [super init]) {
        _dashboardVC = leftSideViewController;
        _discoveryVC = mainViewController;
        _profileVC = rightSideViewController;
        _views = @[_dashboardVC.view, _discoveryVC.view, _profileVC.view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
}


- (void)constructView {
    _navBarItems = @[
                             [self newDashboardNavBarItem],
                             [self newDiscoveryNavBarItem],
                             [self newGuestProfileNavBarItem]
                             ];
    
    _pagingViewController = [self newPagingViewController];
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

- (SLPagingViewController *)newPagingViewController {
    SLPagingViewController *pagingViewController = [[SLPagingViewController alloc] initWithNavBarItems:_navBarItems
                                                                                      navBarBackground:kTHLNUIPrimaryBackgroundColor
                                                                                                 views:_views
                                                                                       showPageControl:NO];
    return pagingViewController;
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
