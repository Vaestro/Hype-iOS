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
#import <RKSwipeBetweenViewControllers/RKSwipeBetweenViewControllers.h>
#import "THLEventTicketViewController.h"
#import "THLMyEventsNavigationViewController.h"
#import "THLPartyNavigationController.h"
#import "THLEventDetailsViewController.h"
#import "THLDiscoveryViewController.h"
#import "THLCheckoutViewController.h"
#import "THLPartyInvitationViewController.h"
#import "THLYapDatabaseManager.h"
#import "THLDataStore.h"
#import "THLGuestEntity.h"
#import "APAddressBook.h"
#import "THLViewDataSourceFactory.h"
#import "THLYapDatabaseViewFactory.h"
#import "THLDependencyManager.h"
#import "THLUserProfileViewController.h"

@interface THLGuestFlowWireframe()
<
THLPerkDetailModuleDelegate,
THLPerkStoreModuleDelegate,
THLLoginModuleDelegate,

THLMyEventsViewDelegate,
THLDiscoveryViewControllerDelegate,
THLEventDetailsViewControllerDelegate,
THLCheckoutViewControllerDelegate,
THLPartyInvitationViewControllerDelegate,
THLUserProfileViewControllerDelegate
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
@property (nonatomic, strong) THLDataStore *contactsDataStore;
@end

@implementation THLGuestFlowWireframe
@synthesize moduleDelegate;

- (instancetype)initWithDependencyManager:(THLDependencyManager *)dependencyManager {
	if (self = [super init]) {
		_dependencyManager = dependencyManager;
	}
	return self;
}

#pragma mark -
#pragma mark MasterTabViewController

- (void)configureMasterTabViewControllerAndPresentGuestFlowInWindow:(UIWindow *)window {
    _window = window;
    UITabBarController *masterTabBarController = [UITabBarController new];
    [self configureMasterTabViewController:masterTabBarController];
    _window.rootViewController = _masterTabBarController;
    [_window makeKeyAndVisible];
}

- (void)configureMasterTabViewController:(UITabBarController *)masterTabBarController {
    _masterTabBarController = masterTabBarController;
    
    UINavigationController *discovery = [UINavigationController new];
    UINavigationController *dashboard = [UINavigationController new];
 

    UINavigationController *perks = [UINavigationController new];
    UINavigationController *profile = [UINavigationController new];
    UIViewController *vc = [UIViewController new];
    
    THLMyEventsViewController *myEventsVC = [[THLMyEventsViewController alloc]initWithClassName:@"GuestlistInvite"];
    myEventsVC.delegate = self;
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    THLMyEventsNavigationViewController *myEventsNavVC = [[THLMyEventsNavigationViewController alloc]initWithRootViewController:pageController];
    [myEventsNavVC.viewControllerArray addObjectsFromArray:@[myEventsVC, vc]];
    myEventsNavVC.buttonText = @[@"TICKETS", @"INVITES"];

    [dashboard addChildViewController:myEventsNavVC];
    
    THLDiscoveryViewController *discoveryVC = [[THLDiscoveryViewController alloc] initWithClassName:@"Event"];
    discoveryVC.delegate = self;
    [discovery pushViewController:discoveryVC animated:NO];

    THLUserProfileViewController *userProfileVC = [THLUserProfileViewController new];
    userProfileVC.delegate = self;
    [profile pushViewController:userProfileVC animated:NO];
    
    [self presentPerkStoreInterfaceInNavigationController:perks];
    
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

#pragma mark -
#pragma mark EventDiscoveryViewController
#pragma mark Delegate

- (void)eventDiscoveryViewControllerWantsToPresentDetailsForEvent:(PFObject *)event {
    THLEventDetailsViewController *eventDetailVC = [[THLEventDetailsViewController alloc]initWithEvent:event andShowNavigationBar:TRUE];
    eventDetailVC.delegate = self;
    [_window.rootViewController presentViewController:eventDetailVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark MyEventsViewController
#pragma mark Delegate

- (void)didSelectViewEventTicket:(PFObject *)guestlistInvite {
    UINavigationController *partyNavVC = [UINavigationController new];
    THLPartyNavigationController *partyNavigationController = [[THLPartyNavigationController alloc] initWithGuestlistInvite:guestlistInvite];
    [partyNavVC addChildViewController:partyNavigationController];
    [_window.rootViewController presentViewController:partyNavVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark EventDetailsViewController
#pragma mark Delegate

- (void)eventDetailsWantsToPresentAdmissionsForEvent:(PFObject *)event {
    THLCheckoutViewController *checkoutVC = [[THLCheckoutViewController alloc] initWithEvent:event paymentInfo:nil];
    checkoutVC.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:checkoutVC];
    [[self topViewController] presentViewController:navVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark CheckoutViewController
#pragma mark Delegate
- (void)checkoutViewControllerDidFinishCheckoutForEvent:(THLEvent *)event withGuestlistId:(NSString *)guestlistId {
    THLPartyInvitationViewController *partyInvitationVC = [[THLPartyInvitationViewController alloc] initWithEvent:event
                                                                                                      guestlistId:guestlistId
                                                                                                           guests:nil
                                                                                                  databaseManager:self.dependencyManager.databaseManager
                                                                                                        dataStore:self.contactsDataStore
                                                                                            viewDataSourceFactory:self.dependencyManager.viewDataSourceFactory
                                                                                                      addressBook:self.dependencyManager.addressBook];
    UINavigationController *invitationNavVC = [[UINavigationController alloc] initWithRootViewController:partyInvitationVC];
    partyInvitationVC.delegate = self;
    [[self topViewController] presentViewController:invitationNavVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark PartyInvitationViewController
#pragma mark Delegate
- (void)partyInvitationViewControllerDidSkipSendingInvitesAndWantsToShowTicket:(PFObject *)invite {
    [_window.rootViewController dismissViewControllerAnimated:YES completion:^{
        UINavigationController *partyNavVC = [UINavigationController new];
        THLPartyNavigationController *partyNavigationController = [[THLPartyNavigationController alloc] initWithGuestlistInvite:invite];
        [partyNavVC addChildViewController:partyNavigationController];
        [_window.rootViewController presentViewController:partyNavVC animated:YES completion:nil];
    }];
}

- (void)partyInvitationViewControllerDidSubmitInvitesAndWantsToShowTicket:(PFObject *)invite {
    [_window.rootViewController dismissViewControllerAnimated:YES completion:^{
        UINavigationController *partyNavVC = [UINavigationController new];
        THLPartyNavigationController *partyNavigationController = [[THLPartyNavigationController alloc] initWithGuestlistInvite:invite];
        [partyNavVC addChildViewController:partyNavigationController];
        [_window.rootViewController presentViewController:partyNavVC animated:YES completion:nil];
    }];
}

#pragma mark -
#pragma mark UserProfileViewController
#pragma mark Delegate
- (void)userProfileViewControllerWantsToLogout {
    [self.moduleDelegate logOutUser];
}

- (THLDataStore *)contactsDataStore
{
    if (!_contactsDataStore) {
        _contactsDataStore = [[THLDataStore alloc] initForEntity:[THLGuestEntity class] databaseManager:self.dependencyManager.databaseManager];
    }
    return _contactsDataStore;
}


- (id<THLGuestFlowModuleInterface>)moduleInterface {
    return self;
}

#pragma mark TopViewController Helper

- (UIViewController *)topViewController{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

- (void)presentPerkStoreInterfaceInNavigationController:(UINavigationController *)navigationController {
    _perkStoreWireframe = [_dependencyManager newPerkStoreWireframe];
    _currentWireframe = _perkStoreWireframe;
    [_perkStoreWireframe.moduleInterface setModuleDelegate:self];
    [_perkStoreWireframe.moduleInterface presentPerkStoreInterfaceInNavigationController:navigationController];
}

- (void)perkModule:(id<THLPerkStoreModuleInterface>)module userDidSelectPerkStoreItemEntity:(THLPerkStoreItemEntity *)perkStoreItemEntity presentPerkDetailInterfaceOnController:(UIViewController *)controller
{
    [self presentPerkDetailInterfaceForPerkStoreItem:perkStoreItemEntity onController:controller];
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

- (void)dealloc
{
    NSLog(@"Destroyed %@", self);
}
@end
