//
//  THLMasterWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//
#import "THLMasterWireframe.h"

//Frameworks
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

//Utilities
#import "THLDependencyManager.h"
#import "THLUserManager.h"
#import "Intercom/intercom.h"
#import "Branch.h"
#import "Mixpanel.h"
#import "THLUser.h"
#import "THLDataStore.h"
#import "THLGuestEntity.h"
#import "SVProgressHUD.h"
#import "THLGuestlistServiceInterface.h"
#import "THLGuestlistService.h"
#import "THLEvent.h"
#import "THLGuestlistInvite.h"
#import "Parse.h"

//Delegates
#import "THLLoginModuleDelegate.h"

//View Controllers
#import "THLOnboardingViewController.h"
#import "THLMyEventsViewController.h"
#import "THLEventTicketViewController.h"
#import "THLMyEventsNavigationViewController.h"
#import "THLPartyNavigationController.h"
#import "THLEventDetailsViewController.h"
#import "THLDiscoveryViewController.h"
#import "THLCheckoutViewController.h"
#import "THLPartyInvitationViewController.h"
#import "THLDependencyManager.h"
#import "THLUserProfileViewController.h"
#import "THLPaymentViewController.h"
#import "THLPerkCollectionViewController.h"
#import "THLPerkDetailViewController.h"
#import "THLAdmissionsViewController.h"
#import "THLTablePackageDetailsViewController.h"
#import "THLLoginViewController.h"

#import "THLPopupNotificationView.h"

@interface THLMasterWireframe()
<
THLLoginModuleDelegate,
THLAdmissionsViewDelegate,
THLTablePackageControllerDelegate,
THLMyEventsViewDelegate,
THLDiscoveryViewControllerDelegate,
THLEventDetailsViewControllerDelegate,
THLCheckoutViewControllerDelegate,
THLPartyInvitationViewControllerDelegate,
THLUserProfileViewControllerDelegate,
THLPartyViewControllerDelegate,
THLPerkCollectionViewControllerDelegate,
THLOnboardingViewControllerDelegate,
THLTablePackageControllerDelegate,
THLLoginViewControllerDelegate
>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UITabBarController *masterTabBarController;
@property (nonatomic, strong) THLUserProfileViewController *userProfileViewController;
@property (nonatomic, strong) THLPerkCollectionViewController *perkCollectionViewController;
@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation THLMasterWireframe
- (instancetype)initWithDependencyManager:(THLDependencyManager *)dependencyManager {
	if (self = [super init]) {
        _dependencyManager = dependencyManager;
	}
	return self;
}

- (void)presentAppInWindow:(UIWindow *)window {
	_window = window;
    if ([THLUserManager isUserCached] && [THLUserManager isUserProfileValid]) {
         [self routeLoggedInUserFlow];
    } else {
        [self presentOnboardingViewController];
    }
}

- (void)routeLoggedInUserFlow
{
    [Intercom registerUserWithUserId:[THLUser currentUser].objectId];
    [Intercom updateUserWithAttributes:@{@"email": [THLUser currentUser].email,
                                         @"name": [THLUser currentUser].fullName
                                        }];
    
    [[Branch getInstance] setIdentity:[THLUser currentUser].objectId];
    
    
    [self configureMasterTabViewControllerAndPresentGuestFlowInWindow:_window];
    
}

- (void)presentOnboardingViewController {
    THLOnboardingViewController *onboardingViewController = [THLOnboardingViewController new];
    onboardingViewController.delegate = self;
    UINavigationController *baseNavigationController = [[UINavigationController alloc] initWithRootViewController:onboardingViewController];
    [baseNavigationController setNavigationBarHidden:YES];
    _window.rootViewController = baseNavigationController;
    [_window makeKeyAndVisible];

}

#pragma mark - Push Notifications
- (BFTask *)handlePushNotification:(NSDictionary *)pushInfo {
    if ([pushInfo objectForKey:@"guestlistInviteId"]) {
        NSString *guestlistInviteId = pushInfo[@"guestl1istInviteId"];
        [[[_dependencyManager guestlistService] fetchGuestlistInviteWithId:guestlistInviteId] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull task) {
            THLGuestlistInvite *invite = task.result;
            THLPopupNotificationView *popupView = [[THLPopupNotificationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.87, SCREEN_HEIGHT*0.67)];
            [popupView setMessageLabelText:@"hello"];
            [popupView setImageViewWithURL:[NSURL URLWithString:invite.event.location.image.url]];
            [popupView setIconURL:[NSURL URLWithString:invite.sender.image.url]];
            [popupView setButtonTitle:@"View Event"];
            
            KLCPopup *popup = [KLCPopup popupWithContentView:popupView
                                                    showType:KLCPopupShowTypeBounceIn
                                                 dismissType:KLCPopupDismissTypeBounceOut
                                                    maskType:KLCPopupMaskTypeDimmed
                                    dismissOnBackgroundTouch:YES
                                       dismissOnContentTouch:YES];
            popup.dimmedMaskAlpha = 0.8;
            [popup show];
            return task;
        }];

        
//        [_guestWireframe showNotificationBadge];
        BFTask *task;
        return task;
    } else {
        NSLog(@"Notification did not have any text");
        return [BFTask taskWithResult:nil];
    }
}

#pragma mark - MasterTabViewController

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


#pragma mark - AdmissionsOptionViewDelegate

- (void)didSelectAdmissionOption:(PFObject *)admissionOption forEvent:(PFObject *)event {
    if ([admissionOption[@"type"] integerValue] == 0) {
        THLCheckoutViewController *checkoutVC = [[THLCheckoutViewController alloc] initWithEvent:event admissionOption:admissionOption];
        checkoutVC.delegate = self;
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:checkoutVC];
        [[self topViewController] presentViewController:navVC animated:YES completion:nil];
    } else if ([admissionOption[@"type"] integerValue] == 1) {
        THLTablePackageDetailsViewController *packageDetailsVC = [[THLTablePackageDetailsViewController alloc] initWithClassName:@"Bottle"];
        packageDetailsVC.delegate = self;
        packageDetailsVC.event = event;
        packageDetailsVC.admissionOption = admissionOption;
        packageDetailsVC.delegate = self;
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:packageDetailsVC];
        [[self topViewController] presentViewController:navVC animated:YES completion:nil];
    }
}

#pragma mark - TablePackageControllerDelegate

- (void)packageControllerWantsToPresentCheckoutForEvent:(PFObject *)event andAdmissionOption:(PFObject *)admissionOption {
    THLCheckoutViewController *checkoutVC = [[THLCheckoutViewController alloc] initWithEvent:event admissionOption:admissionOption];
    checkoutVC.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:checkoutVC];
    [[self topViewController] presentViewController:navVC animated:YES completion:nil];
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

- (void)eventDetailsWantsToPresentAdmissionsForEvent:(PFObject *)event {
    THLAdmissionsViewController *admissionsVC = [[THLAdmissionsViewController alloc] initWithClassName:@"AdmissionOption"];
    admissionsVC.delegate = self;
    admissionsVC.event = event;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:admissionsVC];
    [[self topViewController] presentViewController:navVC animated:YES completion:nil];
}

- (void)eventDetailsWantsToPresentCheckoutForEvent:(PFObject *)event paymentInfo:(NSDictionary *)paymentInfo {
    [self presentCheckoutViewController:event paymentInfo:paymentInfo];
}

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
    [self logOutUser];
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

- (void)partyViewControllerWantsToPresentCheckoutForEvent:(PFObject *)event paymentInfo:(NSDictionary *)paymentInfo {
    [self presentCheckoutViewController:event paymentInfo:paymentInfo];
}

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
    [self presentLoginViewController];
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

- (void)presentCheckoutViewController:(PFObject *)event paymentInfo:(NSDictionary *)paymentInfo {
    THLCheckoutViewController *checkoutVC = [[THLCheckoutViewController alloc] initWithEvent:event paymentInfo:paymentInfo];
    checkoutVC.delegate = self;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:checkoutVC];
    [[self topViewController] presentViewController:navVC animated:YES completion:nil];
}

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
                                                                                                        dataStore:self.dependencyManager.contactsDataStore
                                                                                            viewDataSourceFactory:self.dependencyManager.viewDataSourceFactory
                                                                                                      addressBook:self.dependencyManager.addressBook];
    UINavigationController *invitationNavVC = [[UINavigationController alloc] initWithRootViewController:partyInvitationVC];
    partyInvitationVC.delegate = self;
    [[self topViewController] presentViewController:invitationNavVC animated:YES completion:nil];
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

/**
 *  Delegates
 */


#pragma mark - THLOnboardingViewController
- (void)onboardingViewControllerdidFinishSignup {
        [THLUserManager makeCurrentInstallation];
        [THLUserManager logCrashlyticsUser];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
//        Recommended by MixPanel to identify user by alias on login
        THLUser *user = [THLUser currentUser];
        
        // mixpanel identify: must be called before
        // people properties can be set
        
//        TODO: Call following mixpanel code only when user signs up for the first time. On following logins - only call mixpanel identify with ALIAS ID
        [mixpanel createAlias:user.objectId
                forDistinctID:mixpanel.distinctId];
        // You must call identify if you haven't already
        // (e.g., when your app launches).
        [mixpanel identify:mixpanel.distinctId];
        
        NSString *userSex;
        if (user.sex == THLSexMale) {
            userSex = @"Male";
        } else if (user.sex == THLSexFemale) {
            userSex = @"Female";
        }
        [mixpanel registerSuperPropertiesOnce:@{@"Gender": userSex}];
        [mixpanel.people set:@{@"$first_name": user.firstName,
                               @"$last_name": user.lastName,
                               @"$email": user.email,
                               @"$phone": user.phoneNumber,
                               @"$created": user.createdAt,
                               @"Gender": userSex
                               }];
        
        [mixpanel track:@"CompletedSignup"];
        [self routeLoggedInUserFlow];

}

#pragma mark - THLLoginViewController
- (void)loginViewControllerDidFinishSignup {
    [self onboardingViewControllerdidFinishSignup];
}

- (void)onboardingViewControllerdidSkipSignup {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
     [Intercom registerUnidentifiedUser];
    [mixpanel track:@"SkippedSignup"];
    [self configureMasterTabViewControllerAndPresentGuestFlowInWindow:_window];
}

#pragma mark - UserFlowDelegate
- (void)presentLoginViewController {
    THLLoginViewController *loginViewController = [THLLoginViewController new];
    loginViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [[self topViewController] presentViewController:navigationController animated:YES completion:NULL];
}

- (void)logOutUser {
    [THLUserManager logUserOut];
    [Intercom reset];
    [[Branch getInstance]logout];
    [PFObject unpinAllObjects];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [_dependencyManager.databaseManager dropDB];
    [self presentOnboardingViewController];
}


@end
