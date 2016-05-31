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
THLLoginModuleDelegate,
THLMyEventsViewDelegate,
THLDiscoveryViewControllerDelegate,
THLEventDetailsViewControllerDelegate,
THLCheckoutViewControllerDelegate,
THLPartyInvitationViewControllerDelegate
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
@property (nonatomic, strong) THLYapDatabaseManager *databaseManager;
@property (nonatomic, strong) THLDataStore *contactsDataStore;
@property (nonatomic, strong) THLViewDataSourceFactory *viewDataSourceFactory;
@property (nonatomic, strong) APAddressBook *addressBook;
@property (nonatomic, strong) THLYapDatabaseViewFactory *yapDatabaseViewFactory;

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

- (THLDataStore *)contactsDataStore
{
    if (!_contactsDataStore) {
        _contactsDataStore = [[THLDataStore alloc] initForEntity:[THLGuestEntity class] databaseManager:self.dependencyManager.databaseManager];
    }
    return _contactsDataStore;
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
    _guestlistReviewWireframe = nil;
    _eventDetailWireframe = nil;
    [_masterTabBarController setSelectedIndex:1];
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
