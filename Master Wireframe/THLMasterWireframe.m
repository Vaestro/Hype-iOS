//
//  THLMasterWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLMasterWireframe.h"

//Utilities
#import "THLDependencyManager.h"
#import "THLSessionService.h"

//Wireframes
#import "THLLoginWireframe.h"
#import "THLGuestFlowWireframe.h"
#import "THLHostFlowWireframe.h"
#import "THLEventDetailWireframe.h"
#import "THLPromotionSelectionWireframe.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLPopupNotificationWireframe.h"

//Delegates
#import "THLLoginModuleDelegate.h"
#import "THLEventDetailModuleDelegate.h"
#import "THLPromotionSelectionModuleDelegate.h"
#import "THLGuestlistInvitationModuleDelegate.h"
#import "THLUser.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface THLMasterWireframe()
<
THLLoginModuleDelegate,
THLPopupNotificationModuleDelegate
>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) id currentWireframe;
@property (nonatomic, strong) THLSessionService *sessionService;

@end

@implementation THLMasterWireframe
- (instancetype)initWithDependencyManager:(THLDependencyManager *)dependencyManager {
	if (self = [super init]) {
        _dependencyManager = dependencyManager;
        _sessionService = [[THLSessionService alloc] init];
	}
	return self;
}

- (void)presentAppInWindow:(UIWindow *)window {
	_window = window;
    [_sessionService isUserCached] ? [self routeUserFlow] : [self presentLoginInterface];
}

- (void)routeUserFlow {
    if ([THLUser currentUser].type == THLUserTypeGuest) {
        [self presentGuestFlow];
    }
    else if ([THLUser currentUser].type == THLUserTypeHost) {
        [self presentHostFlow];
    }
}

#pragma mark - Push Notifications
- (BFTask *)handlePushNotification:(NSDictionary *)pushInfo {
    if ([pushInfo objectForKey:@"notificationText"]) {
        THLPopupNotificationWireframe *popupNotificationWireframe = [_dependencyManager newPopupNotificationWireframe];
        [popupNotificationWireframe.moduleInterface setModuleDelegate:self];
        return [popupNotificationWireframe.moduleInterface presentPopupNotificationModuleInterfaceWithPushInfo:pushInfo];
    } else {
        NSLog(@"Notification did not have any text");
        return [BFTask taskWithResult:nil];
    }
}

#pragma mark - Routing
- (void)presentLoginInterface {
	THLLoginWireframe *loginWireframe = [_dependencyManager newLoginWireframe];
    _currentWireframe = loginWireframe;
	[loginWireframe.moduleInterface setModuleDelegate:self];
	[loginWireframe.moduleInterface presentLoginModuleInterfaceInWindow:_window];
}

- (void)presentGuestFlow {
	THLGuestFlowWireframe *guestWireframe = [_dependencyManager newGuestFlowWireframe];
    _currentWireframe = guestWireframe;
	[guestWireframe presentGuestFlowInWindow:_window];
}

- (void)presentGuestFlowForEvent:(THLEventEntity *)eventEntity {
    THLGuestFlowWireframe *guestWireframe = [_dependencyManager newGuestFlowWireframe];
    _currentWireframe = guestWireframe;
    [guestWireframe presentGuestFlowInWindow:_window forEventDetail:eventEntity];
}

- (void)presentHostFlow {
    THLHostFlowWireframe *hostWireframe = [_dependencyManager newHostFlowWireframe];
    _currentWireframe = hostWireframe;
    [hostWireframe presentHostFlowInWindow:_window];
}


#pragma mark - THLPopupNotifcationDelegate
- (void)popupNotificationModule:(id<THLPopupNotificationModuleInterface>)module userDidAcceptReviewForEvent:(THLEventEntity *)eventEntity {
    [self presentGuestFlowForEvent:eventEntity];
}

#pragma mark - THLLoginModuleDelegate
- (void)loginModule:(id<THLLoginModuleInterface>)module didLoginUser:(NSError *)error {
	if (!error) {
        [_sessionService makeCurrentInstallation];
        [_sessionService logCrashlyticsUser];
		[self presentGuestFlow];

    } else {
        NSLog(@"Login Error:%@", error);
    }
}

#pragma mark - THLEventDetailModuleDelegate
//- (void)guestFlowModule:(id<THLGuestFlowModuleInterface>)module {
//    [self presentGuestlistInvitationInterface];
//}

#pragma mark - THLPromotionSelectionModuleDelegate
- (void)promotionSelectionModule:(id<THLPromotionSelectionModuleInterface>)module didSelectPromotion:(THLPromotionEntity *)promotionEntity {
	
}

@end
