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
@property (nonatomic, strong) THLOnboardingViewController *onboardingViewController;
@property (nonatomic, strong) THLLoginViewController *loginViewController;

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
    [THLUserManager makeCurrentInstallation];

    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:[THLUser user].objectId];
    
    [Intercom registerUserWithUserId:[THLUser currentUser].objectId];
    [Intercom updateUserWithAttributes:@{@"email": [THLUser currentUser].email,
                                         @"name": [THLUser currentUser].fullName
                                         }];
    
    [[Branch getInstance] setIdentity:[THLUser currentUser].objectId];
    
    [self configureMasterTabViewControllerAndPresentGuestFlowInWindow:_window];
}

- (void)routeSignedUpUserFlow {
    [THLUserManager makeCurrentInstallation];

    [Intercom registerUserWithUserId:[THLUser currentUser].objectId];
    [Intercom updateUserWithAttributes:@{@"email": [THLUser currentUser].email,
                                         @"name": [THLUser currentUser].fullName
                                         }];
    
    [[Branch getInstance] setIdentity:[THLUser currentUser].objectId];
    
    
    [self configureMasterTabViewControllerAndPresentGuestFlowInWindow:_window];
}



#pragma mark -
#pragma mark - THLOnboardingViewController
- (void)presentOnboardingViewController {
    _onboardingViewController = [THLOnboardingViewController new];
    _onboardingViewController.delegate = self;
    UINavigationController *baseNavigationController = [[UINavigationController alloc] initWithRootViewController:_onboardingViewController];
    [baseNavigationController setNavigationBarHidden:YES];
    _window.rootViewController = baseNavigationController;
    [_window makeKeyAndVisible];
    
}

#pragma mark Delegate
- (void)onboardingViewControllerdidFinishSignup {
    [THLUserManager logCrashlyticsUser];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Completed signup"];
    [PFCloud callFunctionInBackground:@"assignGuestToGuestlistInvite" withParameters:nil];
    [self routeSignedUpUserFlow];
}

- (void)onboardingViewControllerdidSkipSignup {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Skipped signup"];
    [Intercom registerUnidentifiedUser];
    [self configureMasterTabViewControllerAndPresentGuestFlowInWindow:_window];
}

- (void)applicationDidRegisterForRemoteNotifications {
    if (_onboardingViewController) {
        [_onboardingViewController applicationDidRegisterForRemoteNotifications];
    } else if (_loginViewController) {
        [_loginViewController applicationDidRegisterForRemoteNotifications];
    }
}


#pragma mark -
#pragma mark LoginViewController
- (void)usersWantsToLogin {
    [self presentLoginViewController];
}

- (void)presentLoginViewController {
    _loginViewController = [THLLoginViewController new];
    _loginViewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_loginViewController];
    [[self topViewController] presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark Delegate

- (void)loginViewControllerDidFinishSignup {
    [self onboardingViewControllerdidFinishSignup];
}

#pragma mark -
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

- (void)viewInvites {
    if (!([self topViewController] == _masterTabBarController)) {
        [_masterTabBarController dismissViewControllerAnimated:YES completion:nil];
    }
    [_masterTabBarController setSelectedIndex:1];

}

#pragma mark - AdmissionsOptionViewDelegate

- (void)didSelectAdmissionOption:(PFObject *)admissionOption forEvent:(PFObject *)event {
    if ([admissionOption[@"type"] integerValue] == 0) {
        THLCheckoutViewController *checkoutVC = [[THLCheckoutViewController alloc] initWithEvent:event admissionOption:admissionOption guestlistInvite:nil];
        checkoutVC.delegate = self;
        [[self topViewController].navigationController pushViewController:checkoutVC animated:YES];

    } else if ([admissionOption[@"type"] integerValue] == 1) {
        THLTablePackageDetailsViewController *packageDetailsVC = [[THLTablePackageDetailsViewController alloc] initWithClassName:@"Bottle"];
        packageDetailsVC.delegate = self;
        packageDetailsVC.event = event;
        packageDetailsVC.admissionOption = admissionOption;
        packageDetailsVC.delegate = self;
        [[self topViewController].navigationController pushViewController:packageDetailsVC animated:YES];

    }
}

#pragma mark - TablePackageControllerDelegate

- (void)packageControllerWantsToPresentCheckoutForEvent:(PFObject *)event andAdmissionOption:(PFObject *)admissionOption {
    THLCheckoutViewController *checkoutVC = [[THLCheckoutViewController alloc] initWithEvent:event admissionOption:admissionOption guestlistInvite:nil];
    checkoutVC.delegate = self;
    [[self topViewController].navigationController pushViewController:checkoutVC animated:YES];

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

- (void)eventDetailsWantsToPresentPartyForEvent:(PFObject *)guestlistInvite {
    [_window.rootViewController dismissViewControllerAnimated:YES completion:^{
        [self presentPartyNavigationController:guestlistInvite];
    }];
    [_masterTabBarController setSelectedIndex:1];
}

#pragma mark -
#pragma mark CheckoutViewController

- (void)presentCheckoutViewController:(PFObject *)event guestlistInvite:(THLGuestlistInvite *)guestlistInvite admissionOption:(PFObject *)admissionOption {
    THLCheckoutViewController *checkoutVC = [[THLCheckoutViewController alloc] initWithEvent:event admissionOption:admissionOption guestlistInvite:guestlistInvite];
    checkoutVC.delegate = self;
    [[self topViewController].navigationController pushViewController:checkoutVC animated:YES];
}

#pragma mark Delegate
- (void)checkoutViewControllerWantsToPresentPaymentViewController {
    [self presentPaymentViewControllerOn:[self topViewController]];
}
- (void)checkoutViewControllerDidFinishCheckoutForEvent:(THLEvent *)event withGuestlistId:(NSString *)guestlistId {
    [self presentInvitationViewController:event guestlistId:guestlistId currentGuestsPhoneNumbers:nil];
}

#pragma mark -
#pragma mark PaymentViewController
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

#pragma mark Delegate


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
#pragma mark PartyNavigationController

- (void)presentPartyNavigationController:(PFObject *)invite {
    UINavigationController *partyNavVC = [UINavigationController new];
    THLPartyNavigationController *partyNavigationController = [[THLPartyNavigationController alloc] initWithGuestlistInvite:invite];
    [partyNavVC addChildViewController:partyNavigationController];
    [_window.rootViewController presentViewController:partyNavVC animated:YES completion:nil];
    [_masterTabBarController setSelectedIndex:1];
    
}

#pragma mark Delegate
- (void)partyViewControllerWantsToPresentInvitationControllerFor:(THLEvent *)event guestlistId:(NSString *)guestlistId currentGuestsPhoneNumbers:(NSArray *)currentGuestsPhoneNumbers {
    [self presentInvitationViewController:event guestlistId:guestlistId currentGuestsPhoneNumbers:currentGuestsPhoneNumbers];
}

- (void)partyViewControllerWantsToPresentCheckoutForEvent:(PFObject *)event withGuestlistInvite:(THLGuestlistInvite *)guestlistInvite {
    PFQuery *query = [PFQuery queryWithClassName:@"AdmissionOption"];
    [query whereKey:@"location" equalTo:event[@"location"]];
    [query whereKey:@"type" equalTo:@0];
    [query whereKey:@"gender" equalTo:[NSNumber numberWithInt:[THLUser currentUser].sex]];
    
    [SVProgressHUD show];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *admissionOption, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            
        } else {
            [self presentCheckoutViewController:event guestlistInvite:guestlistInvite admissionOption:admissionOption];
        }
    }];
}


#pragma mark -
#pragma mark PartyInvitationViewController
- (void)presentInvitationViewController:(THLEvent *)event guestlistId:(NSString *)guestlistId currentGuestsPhoneNumbers:(NSArray *)currentGuestsPhoneNumbers {
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
#pragma mark PerkCollectionViewController
#pragma mark Delegate

- (void)perkStoreViewControllerWantsToPresentDetailsFor:(PFObject *)perk {
    THLPerkDetailViewController *perkDetailViewController = [[THLPerkDetailViewController alloc] initWithPerk:perk];
    perkDetailViewController.hidesBottomBarWhenPushed = YES;
    [_perkCollectionViewController.navigationController pushViewController:perkDetailViewController animated:YES];
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


#pragma mark - Push Notifications
- (BFTask *)handlePushNotification:(NSDictionary *)pushInfo {
    if ([pushInfo objectForKey:@"guestlistInviteId"]) {
        NSString *guestlistInviteId = pushInfo[@"guestlistInviteId"];
        return [[[_dependencyManager guestlistService] fetchGuestlistInviteWithId:guestlistInviteId] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull task) {
            THLGuestlistInvite *invite = task.result;
            THLPopupNotificationView *popupView = [[THLPopupNotificationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.87, SCREEN_HEIGHT*0.67)];
            [popupView setMessageLabelText:[NSString stringWithFormat:@"%@ has invited you\nto party with friends at\n%@\n%@ at %@", invite.sender.firstName, invite.event.location.name, invite.date.thl_weekdayString, invite.date.thl_timeString]];
            [popupView setImageViewWithURL:[NSURL URLWithString:invite.event.location.image.url]];
            [popupView setIconURL:[NSURL URLWithString:invite.sender.image.url]];
            [popupView setButtonTitle:@"View Invite"];
            [popupView setButtonTarget:self action:@selector(viewInvites) forControlEvents:UIControlEventTouchUpInside];
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
    } else {
        NSLog(@"Notification was not a guestlistInvite");
        return [BFTask taskWithResult:nil];
    }
}

- (void)messageButtonPressed
{
    [Intercom presentMessageComposer];
}

#pragma mark - LogOut Handler

- (void)logOutUser {
    [THLUserManager logUserOut];
    [Intercom reset];
    [[Branch getInstance]logout];
    [PFObject unpinAllObjects];
    [FBSDKAccessToken setCurrentAccessToken:nil];
//    [_dependencyManager.databaseManager dropDB];
    [self presentOnboardingViewController];
}


@end
