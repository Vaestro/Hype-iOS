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
#import "THLEventFlowWireframe.h"
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
THLGuestlistInvitationModuleDelegate
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
        [self presentEventFlow];
    }else {
        [self presentLoginInterface];
    }

}

//- (BFTask *)handlePushNotification:(NSDictionary *)pushInfo {
//    NSString *guestlistInviteId = pushInfo[kPushInfoKeyGuestlistInviteId];
//    _guestlistService = [[THLGuestlistService alloc] initWithQueryFactory:self.parseQueryFactory];
//    _entityMapper = [[THLEntityMapper alloc] init];
//    return [[_guestlistService fetchGuestlistInviteWithId:guestlistInviteId] continueWithSuccessBlock:^id(BFTask *task) {
//        if (!task.faulted) {
//            THLGuestlistInvite *fetchedGuestlistInvite = task.result;
//            THLGuestlistInviteEntity *mappedGuestlistInvite = [_entityMapper mapGuestlistInvite:fetchedGuestlistInvite];
//            [self showPopupForGuestListInviteEntity:mappedGuestlistInvite];
//        }
//        return task;
//    }];
//}

//- (void)showPopupForGuestListInviteEntity:(THLGuestlistInviteEntity *)guestlistInviteEntity {
//    [THLGuestlistInvitePopupView showPopupForGuestlist:guestlistInviteEntity.guestlist callbackBlock:^(BOOL displayGuestList) {
//        if (displayGuestList) {
//            [self presentEventFlowInWindow:guestlistInviteEntity.guestlist.promotion.event];
//        }
//    }];
//}

- (BFTask *)handlePushNotification:(NSDictionary *)pushInfo {
    THLPopupNotificationWireframe *popupNotificationWireframe = [_dependencyManager newPopupNotificationWireframe];
    [popupNotificationWireframe.moduleInterface setModuleDelegate:self];
    return [popupNotificationWireframe.moduleInterface presentPopupNotificationModuleInterfaceWithPushInfo:pushInfo];
}

#pragma mark - Routing
- (void)presentLoginInterface {
	THLLoginWireframe *loginWireframe = [_dependencyManager newLoginWireframe];
	_currentWireframe = loginWireframe;
	[loginWireframe.moduleInterface setModuleDelegate:self];
	[loginWireframe.moduleInterface presentLoginModuleInterfaceInWindow:_window];
}

- (void)presentEventFlow {
	THLEventFlowWireframe *eventWireframe = [_dependencyManager newEventFlowWireframe];
	_currentWireframe = eventWireframe;
	[eventWireframe presentEventFlowInWindow:_window];
}

- (void)presentEventFlowInWindow:(THLEventEntity *)eventEntity {
    THLEventFlowWireframe *eventWireframe = [_dependencyManager newEventFlowWireframe];
    _currentWireframe = eventWireframe;
    [eventWireframe presentEventFlowInWindow:_window forEventDetail:eventEntity];
}
//- (void)presentEventDetailInterfaceForEvent:(THLEventEntity *)eventEntity {
//    THLEventDetailWireframe *eventDetailWireframe = [_dependencyManager newEventDetailWireframe];
//    [eventDetailWireframe.moduleInterface setModuleDelegate:self];
//    [eventDetailWireframe.moduleInterface presentEventDetailInterfaceForEvent:eventEntity inWindow:_window];
//}

//- (void)presentGuestlistInvitationInterface {
//	THLGuestlistInvitationWireframe *guestlistWireframe = [_dependencyManager newGuestlistInvitationWireframe];
//	_currentWireframe = guestlistWireframe;
//	[guestlistWireframe.moduleInterface setModuleDelegate:self];
//	[guestlistWireframe.moduleInterface presentGuestlistInvitationInterfaceForGuestlist:@"1" inWindow:_window];
//}

#pragma mark - THLLoginModuleDelegate
- (void)loginModule:(id<THLLoginModuleInterface>)module didLoginUser:(NSError *)error {
	if (!error) {
		[self presentEventFlow];
	}
}

#pragma mark - THLEventDetailModuleDelegate
//- (void)eventFlowModule:(id<THLEventFlowModuleInterface>)module {
//    [self presentGuestlistInvitationInterface];
//}

#pragma mark - THLPromotionSelectionModuleDelegate
- (void)promotionSelectionModule:(id<THLPromotionSelectionModuleInterface>)module didSelectPromotion:(THLPromotionEntity *)promotionEntity {
	
}

@end
