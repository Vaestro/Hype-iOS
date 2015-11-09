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
#import "THLEventDetailWireframe.h"
#import "THLPromotionSelectionWireframe.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLPopupNotificationWireframe.h"

//Delegates
#import "THLLoginModuleDelegate.h"
#import "THLEventDetailModuleDelegate.h"
#import "THLPromotionSelectionModuleDelegate.h"
#import "THLGuestlistInvitationModuleDelegate.h"

@interface THLMasterWireframe()
<
THLLoginModuleDelegate,
THLPromotionSelectionModuleDelegate,
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
    
    if ([_sessionService isUserCached]) {
//        Potentially Necessasy to update Installation everytime User opens app
//        [_sessionService makeCurrentInstallation];
        [self presentGuestFlow];
    }else {
        [self presentLoginInterface];
    }
}

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

#pragma mark - THLLoginModuleDelegate
- (void)loginModule:(id<THLLoginModuleInterface>)module didLoginUser:(NSError *)error {
    if (!error) {
        [_sessionService makeCurrentInstallation];
        [self presentGuestFlow];
    }
}

#pragma mark - THLPopupNotifcationDelegate
- (void)popupNotificationModule:(id<THLPopupNotificationModuleInterface>)module userDidAcceptReviewForEvent:(THLEventEntity *)eventEntity {
    [self presentGuestFlowForEvent:eventEntity];
}

@end
