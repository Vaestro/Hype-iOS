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
#import "THLChatListViewController.h"

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
@property (nonatomic, strong) UITabBarController *masterTabBarController;
@property (nonatomic, strong) THLEventDiscoveryWireframe *eventDiscoveryWireframe;
@property (nonatomic, strong) THLUserProfileWireframe *userProfileWireframe;
@property (nonatomic, strong) THLHostDashboardWireframe *dashboardWireframe;
@property (nonatomic, strong) THLEventHostingWireframe  *eventHostingWireframe;
@property (nonatomic, strong) THLGuestlistReviewWireframe *guestlistReviewWireframe;
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
- (void)configureMasterTabViewControllerAndPresentHostFlowInWindow:(UIWindow *)window {
    _window = window;
    _masterTabBarController = [UITabBarController new];
    [self configureMasterTabViewController:_masterTabBarController];
    _window.rootViewController = _masterTabBarController;
    [_window makeKeyAndVisible];
}

- (void)configureMasterTabViewController:(UITabBarController *)masterTabViewController {
    UINavigationController *discovery = [UINavigationController new];
    UINavigationController *chat = [UINavigationController new];
    UINavigationController *dashboard = [UINavigationController new];
    UIViewController *profile = [UIViewController new];
    
    [self presentEventDiscoveryInterfaceInNavigationController:discovery];
    [self presentMessageListInterfaceInNavigationController:chat];
    [self presentDashboardInterfaceInNavigationController:dashboard];
    [self presentUserProfileInterfaceInViewController:profile];
    
    dashboard.tabBarItem.image = [UIImage imageNamed:@"Lists Icon"];
    chat.tabBarItem.image = [UIImage imageNamed:@"Lists Icon"];
    discovery.tabBarItem.image = [UIImage imageNamed:@"Home Icon"];
    profile.tabBarItem.image = [UIImage imageNamed:@"Profile Icon"];
    
    NSArray *views = @[discovery, chat, dashboard, profile];
    
    masterTabViewController.viewControllers = views;
    masterTabViewController.view.autoresizingMask=(UIViewAutoresizingFlexibleHeight);
}

- (void)showNotificationBadge {
    [[_masterTabBarController.tabBar.items objectAtIndex:1] setBadgeValue:@""];
}

- (id<THLHostFlowModuleInterface>)moduleInterface {
    return self;
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

- (void)presentEventDiscoveryInterfaceInNavigationController:(UINavigationController *)navigationController {
    _eventDiscoveryWireframe = [_dependencyManager newEventDiscoveryWireframe];
    _currentWireframe = _eventDiscoveryWireframe;
    [_eventDiscoveryWireframe.moduleInterface setModuleDelegate:self];
    [_eventDiscoveryWireframe.moduleInterface presentEventDiscoveryInterfaceInNavigationController:navigationController];
}

- (void)presentMessageListInterfaceInNavigationController:(UINavigationController *)navigationController {
    THLChatListViewController *chtlvtrl = [[THLChatListViewController alloc] init];
    [navigationController showViewController:chtlvtrl sender:nil];
}

- (void)presentDashboardInterfaceInNavigationController:(UINavigationController *)navigationController {
    _dashboardWireframe = [_dependencyManager newHostDashboardWireframe];
    _currentWireframe = _dashboardWireframe;
    [_dashboardWireframe.moduleInterface setModuleDelegate:self];
    [_dashboardWireframe.moduleInterface presentDashboardInterfaceInNavigationController:navigationController];
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
@end