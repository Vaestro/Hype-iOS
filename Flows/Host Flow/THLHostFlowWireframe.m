//
//  THLHostFlowWireframe.m
//  Hypelist2point0
//
//  Created by Edgar Li on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLHostFlowDependencyManager.h"

#import "THLHostFlowWireframe.h"

#import "THLEventDiscoveryWireframe.h"
#import "THLUserProfileWireframe.h"
#import "THLHostDashboardWireframe.h"

#import "THLEventHostingWireframe.h"
#import "THLGuestlistReviewWireframe.h"

#import "THLMasterNavigationController.h"

#import "THLAppearanceConstants.h"

@interface THLHostFlowWireframe()
<
THLEventDiscoveryModuleDelegate,
THLUserProfileModuleDelegate,
THLHostDashboardModuleDelegate,
THLEventHostingModuleDelegate,
THLGuestlistReviewModuleDelegate
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) id currentWireframe;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) THLEventDiscoveryWireframe *eventDiscoveryWireframe;
@property (nonatomic, strong) THLUserProfileWireframe *userProfileWireframe;
@property (nonatomic, strong) THLHostDashboardWireframe *dashboardWireframe;
@property (nonatomic, strong) THLEventHostingWireframe  *eventHostingWireframe;
@property (nonatomic, strong) THLGuestlistReviewWireframe *guestlistReviewWireframe;

@property (nonatomic, strong) UIView *discoveryNavBarItem;
@property (nonatomic, strong) UIView *userProfileNavBarItem;
@property (nonatomic, strong) UIView *dashboardNavBarItem;
@end

@implementation THLHostFlowWireframe
@synthesize moduleDelegate;
- (instancetype)initWithDependencyManager:(id<THLHostFlowDependencyManager>)dependencyManager {
    if (self = [super init]) {
        _dependencyManager = dependencyManager;
    }
    return self;
}

#pragma mark - Routing
- (void)presentHostFlowInWindow:(UIWindow *)window {
    _window = window;
    UIViewController *discovery = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *profile = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    UIViewController *dashboard = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    
    [self presentEventDiscoveryInterfaceInViewController:discovery];
    [self presentDashboardInterfaceInViewController:dashboard];
    [self presentUserProfileInterfaceInViewController:profile];
    
    NSArray *views = @[dashboard, discovery, profile];
    
    NSArray *navBarItems = @[
                             [self newDashboardNavBarItem],
                             [self newDiscoveryNavBarItem],
                             [self newUserProfileNavBarItem]
                             ];
    
    THLMasterNavigationController *masterNavigationController = [[THLMasterNavigationController alloc] initWithNavBarItems:navBarItems navBarBackground:kTHLNUIPrimaryBackgroundColor controllers:views showPageControl:NO];
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:masterNavigationController];
    _window.rootViewController = _navigationController;
    [_window makeKeyAndVisible];
}

- (void)presentHostFlowInWindow:(UIWindow *)window forEventHosting:(THLEventEntity *)eventEntity {
    /**
     *  Prevents popup notification from instantiating another event hosting module if one is already instantiated
     */
    if (_currentWireframe != _eventHostingWireframe) {
        _window = window;
        [self presentEventHostingInterfaceForEvent:eventEntity];
    }
}

- (void)presentEventDiscoveryInterfaceInViewController:(UIViewController *)viewController {
    _eventDiscoveryWireframe = [_dependencyManager newEventDiscoveryWireframe];
    _currentWireframe = _eventDiscoveryWireframe;
    [_eventDiscoveryWireframe.moduleInterface setModuleDelegate:self];
    [_eventDiscoveryWireframe.moduleInterface presentEventDiscoveryInterfaceInViewController:viewController];
}

- (void)presentDashboardInterfaceInViewController:(UIViewController *)viewController {
    _dashboardWireframe = [_dependencyManager newHostDashboardWireframe];
    _currentWireframe = _dashboardWireframe;
    [_dashboardWireframe.moduleInterface setModuleDelegate:self];
    [_dashboardWireframe.moduleInterface presentDashboardInterfaceInViewController:viewController];
}

- (void)presentUserProfileInterfaceInViewController:(UIViewController *)viewController {
    _userProfileWireframe = [_dependencyManager newUserProfileWireframe];
    _currentWireframe = _userProfileWireframe;
    [_userProfileWireframe.moduleInterface setModuleDelegate:self];
    [_userProfileWireframe.moduleInterface presentUserProfileInterfaceInViewController:viewController];
}

- (void)presentEventHostingInterfaceForEvent:(THLEventEntity *)eventEntity {
    _eventHostingWireframe = [_dependencyManager newEventHostingWireframe];
    _currentWireframe = _eventHostingWireframe;
    [_eventHostingWireframe.moduleInterface setModuleDelegate:self];
    [_eventHostingWireframe.moduleInterface presentEventHostingInterfaceForEvent:eventEntity inWindow:_window];
}

- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity inController:(UIViewController *)controller {
    _guestlistReviewWireframe = [_dependencyManager newGuestlistReviewWireframe];
    _currentWireframe = _guestlistReviewWireframe;
    [_guestlistReviewWireframe.moduleInterface setModuleDelegate:self];
    [_guestlistReviewWireframe.moduleInterface presentGuestlistReviewInterfaceForGuestlist:guestlistEntity inController:controller];
}


#pragma mark - THLEventDiscoveryModuleDelegate
- (void)eventDiscoveryModule:(id<THLEventDiscoveryModuleInterface>)module userDidSelectEventEntity:(THLEventEntity *)eventEntity {
    [self presentEventHostingInterfaceForEvent:eventEntity];
}

#pragma mark - THLHostDashboardModuleDelegate
- (void)hostDashboardModule:(id<THLHostDashboardModuleInterface>)module didClickToViewGuestlistReqeust:(THLGuestlistEntity *)guestlist {
    [self presentGuestlistReviewInterfaceForGuestlist:guestlist inController:_window.rootViewController];
}

#pragma mark - THLEventHostingModuleDelegate
- (void)eventHostingModule:(id<THLEventHostingModuleInterface>)module userDidSelectGuestlistEntity:(THLGuestlistEntity *)guestlistEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)controller {
    [self presentGuestlistReviewInterfaceForGuestlist:guestlistEntity inController:controller];
}

- (void)dismissEventHostingWireframe {
    _eventHostingWireframe = nil;
}

#pragma mark - THLGuestlistReviewModuleDelegate
- (void)dismissGuestlistReviewWireframe {
    _guestlistReviewWireframe = nil;
}

#pragma mark - THLUserProfileModuleDelegate
- (void)logOutUser {
    [self.moduleDelegate logOutUser];
}

- (UIView *)newDiscoveryNavBarItem {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Hypelist-Icon"]
                                                                 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tintColor = kTHLNUIGrayFontColor;
    return imageView;
}

- (UIView *)newUserProfileNavBarItem {
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