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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self constructView];
    [self layoutView];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}


- (void)constructView {

}

- (void)layoutView {
    
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
