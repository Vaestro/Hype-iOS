//
//  THLGuestFlowWireframe.m
//  Hypelist2point0
//
//  Created by Edgar Li on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import "THLGuestFlowDependencyManager.h"

#import "THLGuestFlowWireframe.h"
#import "THLUser.h"
#import "Intercom/intercom.h"
#import "THLMyEventsViewController.h"
#import "THLEventTicketViewController.h"
#import "THLMyEventsNavigationViewController.h"
#import "THLPartyNavigationController.h"
#import "THLEventDetailsViewController.h"
#import "THLDiscoveryViewController.h"
#import "THLCheckoutViewController.h"
#import "THLPartyInvitationViewController.h"
#import "THLDataStore.h"
#import "THLDependencyManager.h"
#import "THLUserProfileViewController.h"
#import "THLPaymentViewController.h"
#import "THLPerkCollectionViewController.h"

#import "THLLoginWireframe.h"
#import "THLGuestEntity.h"
#import "SVProgressHUD.h"
#import "THLPerkDetailViewController.h"

@interface THLGuestFlowWireframe()
<
THLLoginModuleDelegate,

THLMyEventsViewDelegate,
THLDiscoveryViewControllerDelegate,
THLEventDetailsViewControllerDelegate,
THLCheckoutViewControllerDelegate,
THLPartyInvitationViewControllerDelegate,
THLUserProfileViewControllerDelegate,
THLPartyViewControllerDelegate,
THLPerkCollectionViewControllerDelegate
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) id currentWireframe;
@property (nonatomic, nonatomic) UIViewController *containerVC;
@property (nonatomic, strong) UITabBarController *masterTabBarController;


@property (nonatomic, strong) THLUserProfileViewController *userProfileViewController;
@property (nonatomic, strong) THLPerkCollectionViewController *perkCollectionViewController;

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
    
    THLMyEventsViewController *myEventsVC = [[THLMyEventsViewController alloc]initWithClassName:@"GuestlistInvite"];
    UINavigationController *dashboard = [UINavigationController new];
    myEventsVC.delegate = self;
    [dashboard pushViewController:myEventsVC animated:NO];
    
    THLDiscoveryViewController *discoveryVC = [[THLDiscoveryViewController alloc] initWithClassName:@"Event"];
    UINavigationController *discovery = [UINavigationController new];

    discoveryVC.delegate = self;
    [discovery pushViewController:discoveryVC animated:NO];

    _userProfileViewController = [THLUserProfileViewController new];
    UINavigationController *profile = [UINavigationController new];
    _userProfileViewController.delegate = self;
    [profile pushViewController:_userProfileViewController animated:NO];
    
    _perkCollectionViewController = [[THLPerkCollectionViewController alloc] initWithClassName:@"PerkStoreItem"];
    _perkCollectionViewController.delegate = self;
    UINavigationController *perks = [UINavigationController new];
    [perks pushViewController:_perkCollectionViewController animated:NO];
    
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
    THLEventDetailsViewController *eventDetailVC = [[THLEventDetailsViewController alloc]initWithEvent:event guestlistInvite:nil showNavigationBar:TRUE];
    eventDetailVC.delegate = self;
    [_window.rootViewController presentViewController:eventDetailVC animated:YES completion:nil];
}
- (void)eventDiscoveryViewControllerWantsToPresentDetailsForAttendingEvent:(PFObject *)event invite:(PFObject *)invite {
    THLEventDetailsViewController *eventDetailVC = [[THLEventDetailsViewController alloc]initWithEvent:event guestlistInvite:invite showNavigationBar:TRUE];
    eventDetailVC.delegate = self;
    [_window.rootViewController presentViewController:eventDetailVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark MyEventsViewController
#pragma mark Delegate

- (void)didSelectViewEventTicket:(PFObject *)guestlistInvite {
    UINavigationController *partyNavVC = [UINavigationController new];
    THLPartyNavigationController *partyNavigationController = [[THLPartyNavigationController alloc] initWithGuestlistInvite:guestlistInvite];
    partyNavigationController.eventDetailsVC.delegate = self;
    partyNavigationController.partyVC.delegate = self;

    [partyNavVC addChildViewController:partyNavigationController];
    [_window.rootViewController presentViewController:partyNavVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark EventDetailsViewController
#pragma mark Delegate

//- (void)eventDetailsWantsToPresentCheckoutForEvent:(PFObject *)event paymentInfo:(NSDictionary *)paymentInfo {
//    [self presentCheckoutViewController:event paymentInfo:paymentInfo];
//}

- (void)eventDetailsWantsToPresentPartyForEvent:(PFObject *)guestlistInvite {
    [_window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self presentPartyNavigationController:guestlistInvite];
    }];
    [_masterTabBarController setSelectedIndex:1];
}

#pragma mark -
#pragma mark CheckoutViewController
#pragma mark Delegate
- (void)checkoutViewControllerWantsToPresentPaymentViewController {
    [self presentPaymentViewControllerOn:[self topViewController]];
}
- (void)checkoutViewControllerDidFinishCheckoutForEvent:(THLEvent *)event withGuestlistId:(NSString *)guestlistId {
    [self presentInvitationViewController:event withGuestlistId:guestlistId];
}


#pragma mark -
#pragma mark PartyInvitationViewController
#pragma mark Delegate
- (void)partyInvitationViewControllerDidSkipSendingInvitesAndWantsToShowTicket:(PFObject *)invite {
    [_window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self presentPartyNavigationController:invite];
    }];

}

- (void)partyInvitationViewControllerDidSubmitInvitesAndWantsToShowTicket:(PFObject *)invite {
    [_window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self presentPartyNavigationController:invite];
    }];

}

#pragma mark -
#pragma mark UserProfileViewController
#pragma mark Delegate
- (void)userProfileViewControllerWantsToLogout {
    [self.moduleDelegate logOutUser];
}

- (void)userProfileViewControllerWantsToPresentPaymentViewController {
    [self presentPaymentViewControllerOn:_userProfileViewController];
}

#pragma mark -
#pragma mark PartyInvitationViewController
#pragma mark Delegate
- (void)partyViewControllerWantsToPresentInvitationControllerFor:(THLEvent *)event guestlistId:(NSString *)guestlistId {
    [self presentInvitationViewController:event withGuestlistId:guestlistId];
}

//- (void)partyViewControllerWantsToPresentCheckoutForEvent:(PFObject *)event paymentInfo:(NSDictionary *)paymentInfo {
//    [self presentCheckoutViewController:event paymentInfo:paymentInfo];
//}

#pragma mark -
#pragma mark PerkCollectionViewController
#pragma mark Delegate

- (void)perkStoreViewControllerWantsToPresentDetailsFor:(PFObject *)perk {
    THLPerkDetailViewController *perkDetailViewController = [[THLPerkDetailViewController alloc] initWithPerk:perk];
    perkDetailViewController.hidesBottomBarWhenPushed = YES;
    [_perkCollectionViewController.navigationController pushViewController:perkDetailViewController animated:YES];
}

#pragma mark -
#pragma mark LoginViewController
#pragma mark Delegate

- (void)usersWantsToLogin {
    [self.moduleDelegate logInUserOnViewController:[self topViewController]];
}

#pragma mark -
#pragma mark View Controller Presenter
#pragma mark Delegate

- (void)presentPartyNavigationController:(PFObject *)invite {
    UINavigationController *partyNavVC = [UINavigationController new];
    THLPartyNavigationController *partyNavigationController = [[THLPartyNavigationController alloc] initWithGuestlistInvite:invite];
    [partyNavVC addChildViewController:partyNavigationController];
    [_window.rootViewController presentViewController:partyNavVC animated:YES completion:nil];
    [_masterTabBarController setSelectedIndex:1];

}

//- (void)presentCheckoutViewController:(PFObject *)event paymentInfo:(NSDictionary *)paymentInfo {
//    THLCheckoutViewController *checkoutVC = [[THLCheckoutViewController alloc] initWithEvent:event paymentInfo:paymentInfo];
//    checkoutVC.delegate = self;
//    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:checkoutVC];
//    [[self topViewController] presentViewController:navVC animated:YES completion:nil];
//}

- (void)presentPaymentViewControllerOn:(UIViewController *)viewController {
    if ([THLUser currentUser].stripeCustomerId) {
        [SVProgressHUD show]; 
        [PFCloud callFunctionInBackground:@"retrievePaymentInfo"
                           withParameters:nil
                                    block:^(NSArray<NSDictionary *> *cardInfo, NSError *cloudError) {
                                        [SVProgressHUD dismiss];
                                        if (cloudError) {
                                            
                                        } else {
                                            THLPaymentViewController *paymentView = [[THLPaymentViewController alloc]initWithPaymentInfo:cardInfo];
                                            paymentView.hidesBottomBarWhenPushed = YES;

                                            [viewController.navigationController pushViewController:paymentView animated:YES];
                                        }
                                    }];
    } else {
        NSArray<NSDictionary *> *emptyCardInfoSet = [[NSArray alloc]init];
        THLPaymentViewController *paymentView = [[THLPaymentViewController alloc]initWithPaymentInfo:emptyCardInfoSet];
        paymentView.hidesBottomBarWhenPushed = YES;
        [viewController.navigationController pushViewController:paymentView animated:YES];
    }
}

- (void)presentInvitationViewController:(THLEvent *)event withGuestlistId:(NSString *)guestlistId {
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

- (void)messageButtonPressed
{
    [Intercom presentMessageComposer];
}

@end
