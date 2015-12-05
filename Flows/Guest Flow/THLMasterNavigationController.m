//
//  THLGuestFlowViewController.m
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLMasterNavigationController.h"

#import "THLAppearanceConstants.h"
#import "UIColor+SLAddition.h"

@interface THLMasterNavigationController()
@property (nonatomic, strong) UIView *discoveryNavBarItem;
@property (nonatomic, strong) UIView *guestProfileNavBarItem;
@property (nonatomic, strong) UIView *dashboardNavBarItem;

@property (nonatomic, strong) NSArray *navBarItems;
@end

@implementation THLMasterNavigationController
//- (instancetype)initWithMainViewController:(UIViewController *)mainViewController
//                   leftSideViewController:(UIViewController *)leftSideViewController
//                      rightSideViewController:(UIViewController *)rightSideViewController {
//    if (self = [super init]) {
//        _dashboardVC = leftSideViewController;
//        _discoveryVC = mainViewController;
//        _profileVC = rightSideViewController;
//        _views = @[_dashboardVC.view, _discoveryVC.view, _profileVC.view];
//    }
//    return self;
//}
//
//-(instancetype)initWithNavBarItems:(NSArray*)items navBarBackground:(UIColor*)background controllers:(NSArray*)controllers {
//    if (self = [super init]) {
//        self = [super initWithNavBarItems:items navBarBackground:background controllers:controllers showPageControl:NO];
//    }
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}


- (void)constructView {

}

- (void)layoutView {
    UIColor *gray = [UIColor colorWithRed:.84
                                    green:.84
                                     blue:.84
                                    alpha:1.0];
    
    UIColor *gold = kTHLNUIAccentColor;
    self.navigationSideItemsStyle = SLNavigationSideItemsStyleOnBounds;
    float minX = 45.0;
    // Tinder Like
    self.pagingViewMoving = ^(NSArray *subviews){
        float mid  = [UIScreen mainScreen].bounds.size.width/2 - minX;
        float midM = [UIScreen mainScreen].bounds.size.width - minX;
        for(UIImageView *v in subviews){
            UIColor *c = gray;
            if(v.frame.origin.x > minX
               && v.frame.origin.x < mid)
                // Left part
                c = [UIColor gradient:v.frame.origin.x
                                  top:minX+1
                               bottom:mid-1
                                 init:gold
                                 goal:gray];
            else if(v.frame.origin.x > mid
                    && v.frame.origin.x < midM)
                // Right part
                c = [UIColor gradient:v.frame.origin.x
                                  top:mid+1
                               bottom:midM-1
                                 init:gray
                                 goal:gold];
            else if(v.frame.origin.x == mid)
                c = gold;
            v.tintColor= c;
        }
    };
    [self setCurrentIndex:1 animated:NO];
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
