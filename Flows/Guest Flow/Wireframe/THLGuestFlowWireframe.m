//
//  THLGuestFlowWireframe.m
//  Hypelist2point0
//
//  Created by Edgar Li on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import "THLGuestFlowDependencyManager.h"

#import "THLGuestFlowWireframe.h"

#import "THLEventDiscoveryWireframe.h"
#import "THLDashboardWireframe.h"
#import "THLUserProfileWireframe.h"
#import "THLLoginWireframe.h"
#import "THLEventDetailWireframe.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLGuestlistReviewWireframe.h"
#import "THLPerkStoreWireframe.h"
#import "THLPerkDetailWireframe.h"
#import "UIColor+SLAddition.h"
#import "THLAppearanceConstants.h"
#import "THLUser.h"
#import "Intercom/intercom.h"
#import "THLMyEventsViewController.h"

@interface THLGuestFlowWireframe()
<
THLEventDiscoveryModuleDelegate,
THLDashboardModuleDelegate,
THLUserProfileModuleDelegate,
THLEventDetailModuleDelegate,
THLGuestlistInvitationModuleDelegate,
THLGuestlistReviewModuleDelegate,
THLPerkDetailModuleDelegate,
THLPerkStoreModuleDelegate,
THLLoginModuleDelegate
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) id currentWireframe;
@property (nonatomic, nonatomic) UIViewController *containerVC;
@property (nonatomic, strong) UITabBarController *masterTabBarController;
@property (nonatomic, strong) THLEventDiscoveryWireframe *eventDiscoveryWireframe;
@property (nonatomic, strong) THLDashboardWireframe *dashboardWireframe;
@property (nonatomic, strong) THLUserProfileWireframe *userProfileWireframe;
@property (nonatomic, strong) THLEventDetailWireframe  *eventDetailWireframe;
@property (nonatomic, strong) THLGuestlistInvitationWireframe *guestlistInvitationWireframe;
@property (nonatomic, strong) THLGuestlistReviewWireframe *guestlistReviewWireframe;
@property (nonatomic, strong) THLPerkStoreWireframe *perkStoreWireframe;
@property (nonatomic, strong) THLPerkDetailWireframe *perkDetailWireframe;
@property (nonatomic, strong) THLLoginWireframe *loginWireframe;

@property (nonatomic, strong) UIView *discoveryNavBarItem;
@property (nonatomic, strong) UIView *guestProfileNavBarItem;
@property (nonatomic, strong) UIView *dashboardNavBarItem;

@end

@implementation THLGuestFlowWireframe
@synthesize moduleDelegate;

- (instancetype)initWithDependencyManager:(id<THLGuestFlowDependencyManager>)dependencyManager {
	if (self = [super init]) {
		_dependencyManager = dependencyManager;
	}
	return self;
}

- (void)configureMasterTabViewControllerAndPresentGuestFlowInWindow:(UIWindow *)window {
    _window = window;
    UITabBarController *masterTabBarController = [UITabBarController new];
    [self configureMasterTabViewController:masterTabBarController];
    _window.rootViewController = _masterTabBarController;
    [_window makeKeyAndVisible];
}

//- (void)showNotificationBadge {
//    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//    f.numberStyle = NSNumberFormatterDecimalStyle;
//    NSString *badgeString = [_masterTabBarController.tabBar.items objectAtIndex:1].badgeValue;
//    NSNumber *currentBadgeValue = [f numberFromString:badgeString];
//    if (currentBadgeValue == nil) {
//        [[_masterTabBarController.viewControllers objectAtIndex:1] tabBarItem].badgeValue = @"1";
//    } else {
//        NSNumber *newBadgeValue = [NSNumber numberWithFloat:([currentBadgeValue floatValue] + 1)];
//        [[_masterTabBarController.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%@", newBadgeValue]];
//    }
//}

//- (void)showNotificationBadge {
//    [[_masterTabBarController.tabBar.items objectAtIndex:1] setBadgeValue:@""];
//}

- (void)configureMasterTabViewController:(UITabBarController *)masterTabBarController {
    _masterTabBarController = masterTabBarController;
    
    UINavigationController *discovery = [UINavigationController new];
    UINavigationController *dashboard = [UINavigationController new];
    UINavigationController *perks = [UINavigationController new];
    UINavigationController *profile = [UINavigationController new];
    
    [self presentDashboardInterfaceInNavigationController:dashboard];
//    THLMyEventsViewController *myEventsVC = [[THLMyEventsViewController alloc]initWithClassName:@"GuestlistInvite"];
//    [dashboard pushViewController:myEventsVC animated:NO];
    
    [self presentDashboardInterfaceInNavigationController:dashboard];
    [self presentEventDiscoveryInterfaceInNavigationController:discovery];
    [self presentPerkStoreInterfaceInNavigationController:perks];
    [self presentUserProfileInterfaceInNavigationController:profile];
    
    dashboard.tabBarItem.image = [UIImage imageNamed:@"Lists Icon"];
    dashboard.tabBarItem.title = @"My Events";
    discovery.tabBarItem.image = [UIImage imageNamed:@"Home Icon"];
    discovery.tabBarItem.title = @"Discover";
    profile.tabBarItem.image = [UIImage imageNamed:@"Profile Icon"];
    profile.tabBarItem.title = @"Profile";
    perks.tabBarItem.image = [UIImage imageNamed:@"Perks Icon"];
    perks.tabBarItem.title = @"Perks";
    
    NSArray *views = @[discovery, dashboard, perks, profile];
    
    _masterTabBarController.viewControllers = views;
    [_masterTabBarController setSelectedIndex:0];
    _masterTabBarController.view.autoresizingMask=(UIViewAutoresizingFlexibleHeight);
}

- (void)presentGuestFlowInWindow:(UIWindow *)window forEventDetail:(THLEventEntity *)eventEntity {
    /**
     *  Prevents popup notification from instantiating another event detail module if one is already instantiated
     */
    [self presentEventDetailInterfaceForEvent:eventEntity onViewController:_window.rootViewController];
}

- (id<THLGuestFlowModuleInterface>)moduleInterface {
    return self;
}


- (void)presentEventDiscoveryInterfaceInNavigationController:(UINavigationController *)navigationController {
	_eventDiscoveryWireframe = [_dependencyManager newEventDiscoveryWireframe];
    _currentWireframe = _eventDiscoveryWireframe;
	[_eventDiscoveryWireframe.moduleInterface setModuleDelegate:self];
	[_eventDiscoveryWireframe.moduleInterface presentEventDiscoveryInterfaceInNavigationController:navigationController];
}

- (void)presentDashboardInterfaceInNavigationController:(UINavigationController *)navigationController {
    _dashboardWireframe = [_dependencyManager newDashboardWireframe];
    _currentWireframe = _dashboardWireframe;
    [_dashboardWireframe.moduleInterface setModuleDelegate:self];
    [_dashboardWireframe.moduleInterface presentDashboardInterfaceInNavigationController:navigationController];
}

- (void)presentUserProfileInterfaceInNavigationController:(UINavigationController *)navigationController {
    _userProfileWireframe = [_dependencyManager newUserProfileWireframe];
    _currentWireframe = _userProfileWireframe;
    [_userProfileWireframe.moduleInterface setModuleDelegate:self];
    [_userProfileWireframe.moduleInterface presentUserProfileInterfaceInNavigationController:navigationController];
}

- (void)presentPerkStoreInterfaceInNavigationController:(UINavigationController *)navigationController {
    _perkStoreWireframe = [_dependencyManager newPerkStoreWireframe];
    _currentWireframe = _perkStoreWireframe;
    [_perkStoreWireframe.moduleInterface setModuleDelegate:self];
    [_perkStoreWireframe.moduleInterface presentPerkStoreInterfaceInNavigationController:navigationController];
}

- (void)presentEventDetailInterfaceForEvent:(THLEventEntity *)eventEntity onViewController:(UIViewController *)viewController {
	_eventDetailWireframe = [_dependencyManager newEventDetailWireframe];
    _currentWireframe = _eventDetailWireframe;
    [_eventDetailWireframe.moduleInterface setModuleDelegate:self];
	[_eventDetailWireframe.moduleInterface presentEventDetailInterfaceForEvent:eventEntity onViewController:viewController];
}

- (void)presentGuestlistInvitationInterfaceForEvent:(THLEventEntity *)eventEntity inController:(UIViewController *)controller {
	_guestlistInvitationWireframe = [_dependencyManager newGuestlistInvitationWireframe];
    _currentWireframe = _guestlistInvitationWireframe;
    [_guestlistInvitationWireframe.moduleInterface setModuleDelegate:self];
	[_guestlistInvitationWireframe.moduleInterface presentGuestlistInvitationInterfaceForEvent:eventEntity inController:controller];
}

- (void)presentGuestlistInvitationInterfaceForEvent:(THLEventEntity *)eventEntity withGuestlistId:(NSString *)guestlistId andGuests:(NSArray<THLGuestEntity *> *)guests inController:(UIViewController *)controller {
    _guestlistInvitationWireframe = [_dependencyManager newGuestlistInvitationWireframe];
    _currentWireframe = _guestlistInvitationWireframe;
    [_guestlistInvitationWireframe.moduleInterface setModuleDelegate:self];
    [_guestlistInvitationWireframe.moduleInterface presentGuestlistInvitationInterfaceForEvent:eventEntity withGuestlistId:guestlistId andGuests:guests inController:controller];
}
     
- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity withGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity inController:(UIViewController *)controller andShowInstruction:(BOOL)showInstruction {
    _guestlistReviewWireframe = [_dependencyManager newGuestlistReviewWireframe];
    _currentWireframe = _guestlistReviewWireframe;
    [_guestlistReviewWireframe.moduleInterface setModuleDelegate:self];
    [_guestlistReviewWireframe.moduleInterface presentGuestlistReviewInterfaceForGuestlist:guestlistEntity withGuestlistInvite:guestlistInviteEntity inController:controller andShowInstruction:showInstruction];
}

- (void)presentPerkDetailInterfaceForPerkStoreItem:(THLPerkStoreItemEntity *)perkStoreItemEntity onController:(UIViewController *)controller {
    _perkDetailWireframe = [_dependencyManager newPerkDetailWireframe];
    _currentWireframe = _perkDetailWireframe;
    [_perkDetailWireframe.moduleInterface setModuleDelegate:self];
    [_perkDetailWireframe.moduleInterface presentPerkDetailInterfaceForPerk:perkStoreItemEntity onViewController:controller];
}

- (void)messageButtonPressed
{
    [Intercom presentMessageComposer];
}


#pragma mark - THLDashboardModuleDelegate
- (void)dashboardModule:(id<THLDashboardModuleInterface>)module didClickToViewEvent:(THLEventEntity *)event
{
    [self presentEventDetailInterfaceForEvent:event onViewController:_window.rootViewController];
}

- (void)dashboardModule:(id<THLDashboardModuleInterface>)module didClickToViewGuestlist:(THLGuestlistEntity *)guestlistEntity guestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)controller
{
    [self presentGuestlistReviewInterfaceForGuestlist:guestlistEntity withGuestlistInvite:guestlistInviteEntity inController:controller andShowInstruction:FALSE];
}

#pragma mark - THLEventDiscoveryModuleDelegate
- (void)eventDiscoveryModule:(id<THLEventDiscoveryModuleInterface>)module userDidSelectEventEntity:(THLEventEntity *)eventEntity
{
    [self presentEventDetailInterfaceForEvent:eventEntity onViewController:_window.rootViewController];
}

#pragma mark - THLEventDetailModuleDelegate

- (void)userNeedsLoginOnViewController:(UIViewController *)viewController
{
    [self.moduleDelegate logInUserOnViewController:viewController];
}

- (void)eventDetailModule:(id<THLEventDetailModuleInterface>)module event:(THLEventEntity *)eventEntity withGuestlistId:(NSString *)guestlistId presentGuestlistInvitationInterfaceOnController:(UIViewController *)controller
{
    [self presentGuestlistInvitationInterfaceForEvent:eventEntity withGuestlistId:guestlistId andGuests:nil inController:controller];
}

- (void)eventDetailModule:(id<THLEventDetailModuleInterface>)module guestlist:(THLGuestlistEntity *)guestlistEntity guestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)controller
{
    [self presentGuestlistReviewInterfaceForGuestlist:guestlistEntity withGuestlistInvite:guestlistInviteEntity inController:controller andShowInstruction:FALSE];
}

- (void)dismissEventDetailWireframe
{
    _eventDetailWireframe = nil;
}

#pragma mark - THLGuestlistInvitationModuleDelegate
- (void)dismissGuestlistInvitationWireframe
{
    _guestlistInvitationWireframe = nil;
}

- (void)dismissWireframeAndPresentGuestlistReviewWireframeFor:(THLGuestlistInviteEntity *)guestlistInvite guestlist:(THLGuestlistEntity *)guestlist
{
    _guestlistInvitationWireframe = nil;
    _guestlistReviewWireframe = nil;
    _eventDetailWireframe = nil;
    [_masterTabBarController setSelectedIndex:1];
    [self presentGuestlistReviewInterfaceForGuestlist:guestlist withGuestlistInvite:guestlistInvite inController:_window.rootViewController andShowInstruction:TRUE];
}



#pragma mark - THLGuestlistReviewModuleDelegate
- (void)guestlistReviewModule:(id<THLGuestlistReviewModuleInterface>)module event:(THLEventEntity *)eventEntity withGuestlistId:(NSString *)guestlistId andGuests:(NSArray<THLGuestEntity *> *)guests presentGuestlistInvitationInterfaceOnController:(UIViewController *)controller
{
    [self presentGuestlistInvitationInterfaceForEvent:eventEntity withGuestlistId:guestlistId andGuests:guests inController:controller];
}

- (void)guestlistReviewModule:(id<THLGuestlistReviewModuleInterface>)module userDidSelectViewEventEntity:(THLEventEntity *)eventEntity onViewController:(UIViewController *)viewController
{
    [self presentEventDetailInterfaceForEvent:eventEntity onViewController:viewController];
}

- (void)dismissGuestlistReviewWireframe
{
    _guestlistReviewWireframe = nil;
}

#pragma mark - THLChatRoomModuleDelegate
- (void)perkModule:(id<THLPerkStoreModuleInterface>)module userDidSelectPerkStoreItemEntity:(THLPerkStoreItemEntity *)perkStoreItemEntity presentPerkDetailInterfaceOnController:(UIViewController *)controller
{
    [self presentPerkDetailInterfaceForPerkStoreItem:perkStoreItemEntity onController:controller];
}

#pragma mark - THLPerkStoreModuleDelegate
- (void)dismissPerkWireframe
{
    _perkStoreWireframe = nil;
}

#pragma mark - THLPerkDetailModuleDelegate
- (void)dismissPerkDetailWireframe
{
    _perkDetailWireframe = nil;
}

#pragma mark - THLUserProfileModuleDelegate
- (void)logOutUser
{
    [self.moduleDelegate logOutUser];
}

- (void)dealloc
{
    NSLog(@"Destroyed %@", self);
}
@end
