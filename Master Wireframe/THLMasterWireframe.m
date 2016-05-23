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
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "THLMasterWireframe.h"

//Utilities
#import "THLDependencyManager.h"
#import "THLUserManager.h"
#import "Intercom/intercom.h"
#import "THLUser.h"

//Wireframes
#import "THLLoginWireframe.h"
#import "THLGuestFlowWireframe.h"
#import "THLEventDetailWireframe.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLPopupNotificationWireframe.h"

//Delegates
#import "THLLoginModuleDelegate.h"
#import "THLGuestFlowModuleDelegate.h"


#define ENABLE_WAITLIST

@interface THLMasterWireframe()
<
THLLoginModuleDelegate,
THLGuestFlowModuleDelegate,
THLPopupNotificationModuleDelegate
>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) id currentWireframe;
@property (nonatomic, strong) THLGuestFlowWireframe *guestWireframe;

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
    if ([THLUserManager isUserCached]) {
        [THLUserManager isUserProfileValid] ? [self routeLoggedInUserFlow] : [self presentUserVerification];
    } else {
        [self presentOnboardingAndLoginInterface];
    }
}

- (void)routeLoggedInUserFlow
{
    [Intercom registerUserWithUserId:[THLUser currentUser].objectId];
    [Intercom updateUserWithAttributes:@{@"email": [THLUser currentUser].email,
                                         @"name": [THLUser currentUser].fullName
                                        }];
    [self presentGuestFlow];
    
}

#pragma mark - Push Notifications
- (BFTask *)handlePushNotification:(NSDictionary *)pushInfo {
    if ([pushInfo objectForKey:@"notificationText"]) {
        THLPopupNotificationWireframe *popupNotificationWireframe = [_dependencyManager newPopupNotificationWireframe];
        _currentWireframe = popupNotificationWireframe;
        [popupNotificationWireframe.moduleInterface setModuleDelegate:self];
        BFTask *task = [popupNotificationWireframe.moduleInterface presentPopupNotificationModuleInterfaceWithPushInfo:pushInfo];
        [_guestWireframe showNotificationBadge];
        if (task.result) {
  
        }
        return task;
    } else {
        NSLog(@"Notification did not have any text");
        return [BFTask taskWithResult:nil];
    }
}

#pragma mark - Routing
/**
 *  present modules by setting their delegates to Master Wireframe and calling the module's presenter to initialize the view on the stack
 */

- (void)presentUserVerification {
    THLLoginWireframe *loginWireframe = [_dependencyManager newLoginWireframe];
    [loginWireframe.moduleInterface setModuleDelegate:self];
    [loginWireframe presentUserVerificationInterfaceInWindow:_window];
}

- (void)presentOnboardingAndLoginInterface {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//
//    BOOL userApproved = [userDefaults boolForKey:@"userApproved"];
//
//    if (userApproved) {
        THLLoginWireframe *loginWireframe = [_dependencyManager newLoginWireframe];
        _currentWireframe = loginWireframe;
        [loginWireframe.moduleInterface setModuleDelegate:self];
        [loginWireframe.moduleInterface presentLoginModuleInterfaceWithOnboardingInWindow:_window];
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


/**
 *  Delegates
 */

#pragma mark - THLPopupNotifcationDelegate
- (void)popupNotificationModule:(id<THLPopupNotificationModuleInterface>)module userDidAcceptReviewForEvent:(THLEventEntity *)eventEntity {
    [self presentGuestFlowForEvent:eventEntity];
}


#pragma mark - THLLoginModuleDelegate
- (void)loginModule:(id<THLLoginModuleInterface>)module didLoginUser:(NSError *)error {
	if (!error) {
        [THLUserManager logCrashlyticsUser];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"CompletedSignup"];
        [self routeLoggedInUserFlow];
    } else {
        NSLog(@"Login Error:%@", error);
    }
}

- (void)skipUserLogin {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
     [Intercom registerUnidentifiedUser];
    [mixpanel track:@"SkippedSignup"];
    [self presentGuestFlow];
}

#pragma mark - UserFlowDelegate
- (void)logInUserOnViewController:(UIViewController *)viewController {
    [self presentLoginInterfaceOnViewController:viewController];
}

- (void)logOutUser {
    [THLUserManager logUserOut];
    [Intercom reset];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [_dependencyManager.databaseManager dropDB];
    _guestWireframe = nil;
    [self presentOnboardingAndLoginInterface];
}


@end
