//
//  THLMasterWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

//Frameworks
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "THLMasterWireframe.h"

//Utilities
#import "THLDependencyManager.h"
#import "THLUserManager.h"

//Wireframes
#import "THLLoginWireframe.h"
#import "THLGuestFlowWireframe.h"
#import "THLHostFlowWireframe.h"
#import "THLEventDetailWireframe.h"
#import "THLPromotionSelectionWireframe.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLPopupNotificationWireframe.h"
#import "THLWaitlistPresenter.h" //Equivalent of wireframe for this instance

//Delegates
#import "THLLoginModuleDelegate.h"
#import "THLGuestFlowModuleDelegate.h"
#import "THLHostFlowModuleDelegate.h"


#define ENABLE_WAITLIST

@interface THLMasterWireframe()
<
THLLoginModuleDelegate,
THLGuestFlowModuleDelegate,
THLHostFlowModuleDelegate,
THLPopupNotificationModuleDelegate,
THLWaitlistPresenterDelegate
>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) id currentWireframe;
@property (nonatomic, strong) THLGuestFlowWireframe *guestWireframe;
@property (nonatomic, strong) THLHostFlowWireframe *hostWireframe;
@property (nonatomic, strong) THLWaitlistPresenter *waitlistPresenter;

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
    [THLUserManager isUserCached] ? [self routeLoggedInUserFlow] : [self presentOnboardingAndLoginInterface];
}

- (void)routeLoggedInUserFlow {
    if ([THLUserManager userIsGuest]) {
        [self presentGuestFlow];
    }
    else if ([THLUserManager userIsHost]) {
        [self presentHostFlow];
    }
}

#pragma mark - Push Notifications
- (BFTask *)handlePushNotification:(NSDictionary *)pushInfo {
    if ([pushInfo objectForKey:@"notificationText"]) {
        THLPopupNotificationWireframe *popupNotificationWireframe = [_dependencyManager newPopupNotificationWireframe];
        _currentWireframe = popupNotificationWireframe;
        [popupNotificationWireframe.moduleInterface setModuleDelegate:self];
        return [popupNotificationWireframe.moduleInterface presentPopupNotificationModuleInterfaceWithPushInfo:pushInfo];
    } else {
        NSLog(@"Notification did not have any text");
        return [BFTask taskWithResult:nil];
    }
}

#pragma mark - Routing
/**
 *  present modules by setting their delegates to Master Wireframe and calling the module's presenter to initialize the view on the stack
 */

- (void)presentOnboardingAndLoginInterface {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL userApproved = [userDefaults objectForKey:@"userApproved"];
    if (userApproved) {
        THLLoginWireframe *loginWireframe = [_dependencyManager newLoginWireframe];
        _currentWireframe = loginWireframe;
        [loginWireframe.moduleInterface setModuleDelegate:self];
        [loginWireframe.moduleInterface presentLoginModuleInterfaceWithOnboardingInWindow:_window];
    } else {
        THLWaitlistPresenter *waitlistPresenter = [_dependencyManager newWaitlistPresenter];
        _waitlistPresenter = waitlistPresenter;
        _waitlistPresenter.delegate = self;
        [waitlistPresenter presentInterfaceInWindow:_window];
    }
}

- (void)presentLoginInterfaceOnViewController:(UIViewController *)viewController {
    THLLoginWireframe *loginWireframe = [_dependencyManager newLoginWireframe];
    _currentWireframe = loginWireframe;
    [loginWireframe.moduleInterface setModuleDelegate:self];
    [loginWireframe.moduleInterface presentLoginModuleInterfaceOnViewController:viewController];
}

- (void)presentGuestFlow {
	_guestWireframe = [_dependencyManager newGuestFlowWireframe];
    _currentWireframe = _guestWireframe;
    [_guestWireframe.moduleInterface setModuleDelegate:self];
	[_guestWireframe configureMasterTabViewControllerAndPresentGuestFlowInWindow:_window];
}

// Route to Event Detail within GuestFlow Module from Popup Module
- (void)presentGuestFlowForEvent:(THLEventEntity *)eventEntity {
    _guestWireframe = [_dependencyManager newGuestFlowWireframe];
    _currentWireframe = _guestWireframe;
    [_guestWireframe.moduleInterface setModuleDelegate:self];
    [_guestWireframe presentGuestFlowInWindow:_window forEventDetail:eventEntity];
}

- (void)presentHostFlow {
    _hostWireframe = [_dependencyManager newHostFlowWireframe];
    _currentWireframe = _hostWireframe;
    [_hostWireframe.moduleInterface setModuleDelegate:self];
    [_hostWireframe presentHostFlowModuleInterfaceInWindow:_window];
}

/**
 *  Delegates
 */

#pragma mark - THLPopupNotifcationDelegate
- (void)popupNotificationModule:(id<THLPopupNotificationModuleInterface>)module userDidAcceptReviewForEvent:(THLEventEntity *)eventEntity {
    [self presentGuestFlowForEvent:eventEntity];
}

#pragma mark - THLWaitlistPresenterDelegate
- (void)didApproveUserForApp {
    [self updateUserDefaultsToApproved];
    [self presentOnboardingAndLoginInterface];
}

- (void)updateUserDefaultsToApproved {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:TRUE forKey:@"userApproved"];
    [userDefaults synchronize];
}

#pragma mark - THLLoginModuleDelegate
- (void)loginModule:(id<THLLoginModuleInterface>)module didLoginUser:(NSError *)error {
	if (!error) {
        [THLUserManager makeCurrentInstallation];
        [THLUserManager logCrashlyticsUser];
		[self routeLoggedInUserFlow];
    } else {
        NSLog(@"Login Error:%@", error);
    }
}

- (void)skipUserLogin {
    [self presentGuestFlow];
}

#pragma mark - UserFlowDelegate
- (void)logInUserOnViewController:(UIViewController *)viewController {
    [self presentLoginInterfaceOnViewController:viewController];
}

- (void)logOutUser {
    [THLUserManager logUserOut];
    [self presentOnboardingAndLoginInterface];
}


@end
