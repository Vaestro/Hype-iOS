//
//  THLEventFlowWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import "THLEventFlowDependencyManager.h"

#import "THLEventFlowWireframe.h"
#import "THLEventDetailWireframe.h"
#import "THLEventDiscoveryWireframe.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLGuestlistReviewWireframe.h"

typedef NS_OPTIONS(NSInteger, THLGuestlistReviewOptions) {
    THLGuestlistReviewOptionsAcceptDeclineGuestlistInvite = 0,
    THLGuestlistReviewOptionsLeaveGuestlist,
    THLGuestlistReviewOptionsAddRemoveGuests,
    THLGuestlistReviewOptionsAcceptDeclineGuestlist,
    THLGuestlistReviewOptionsConfirmGuestlistInvites,
    THLGuestlistReviewOptions_Count
};

@interface THLEventFlowWireframe()
<
THLEventDiscoveryModuleDelegate,
THLEventDetailModuleDelegate,
THLGuestlistInvitationModuleDelegate,
THLGuestlistReviewModuleDelegate
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) THLEventDiscoveryWireframe *eventDiscoveryWireframe;
@property (nonatomic, strong) THLEventDetailWireframe  *eventDetailWireframe;
@property (nonatomic, strong) THLGuestlistInvitationWireframe *guestlistInvitationWireframe;
@property (nonatomic, strong) THLGuestlistReviewWireframe *guestlistReviewWireframe;
@end

@implementation THLEventFlowWireframe
- (instancetype)initWithDependencyManager:(id<THLEventFlowDependencyManager>)dependencyManager {
	if (self = [super init]) {
		_dependencyManager = dependencyManager;
	}
	return self;
}

#pragma mark - Routing
- (void)presentEventFlowInWindow:(UIWindow *)window {
	_window = window;
	[self presentEventDiscoveryInterface];
}

- (void)presentEventFlowInWindow:(UIWindow *)window forEventDetail:(THLEventEntity *)eventEntity {
    _window = window;
    [self presentEventDetailInterfaceForEvent:eventEntity];
}

- (void)presentEventDiscoveryInterface {
	_eventDiscoveryWireframe = [_dependencyManager newEventDiscoveryWireframe];
	[_eventDiscoveryWireframe.moduleInterface setModuleDelegate:self];
	[_eventDiscoveryWireframe.moduleInterface presentEventDiscoveryInterfaceInWindow:_window];
}

- (void)presentEventDetailInterfaceForEvent:(THLEventEntity *)eventEntity {
	_eventDetailWireframe = [_dependencyManager newEventDetailWireframe];
    [_eventDetailWireframe.moduleInterface setModuleDelegate:self];
	[_eventDetailWireframe.moduleInterface presentEventDetailInterfaceForEvent:eventEntity inWindow:_window];
}


- (void)presentGuestlistInvitationInterfaceForPromotion:(THLPromotionEntity *)promotionEntity inController:(UIViewController *)controller {
	_guestlistInvitationWireframe = [_dependencyManager newGuestlistInvitationWireframe];
    [_guestlistInvitationWireframe.moduleInterface setModuleDelegate:self];
	[_guestlistInvitationWireframe.moduleInterface presentGuestlistInvitationInterfaceForPromotion:promotionEntity inController:controller];
}

- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity withGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity inController:(UIViewController *)controller {
    _guestlistReviewWireframe = [_dependencyManager newGuestlistReviewWireframe];
    [_guestlistReviewWireframe.moduleInterface setModuleDelegate:self];
    [_guestlistReviewWireframe.moduleInterface presentGuestlistReviewInterfaceForGuestlist:guestlistEntity withGuestlistInvite:guestlistInviteEntity inController:controller];
}


#pragma mark - THLEventDiscoveryModuleDelegate
- (void)eventDiscoveryModule:(id<THLEventDiscoveryModuleInterface>)module userDidSelectEventEntity:(THLEventEntity *)eventEntity {
	[self presentEventDetailInterfaceForEvent:eventEntity];
}

#pragma mark - THLEventDetailModuleDelegate

- (void)eventDetailModule:(id<THLEventDetailModuleInterface>)module promotion:(THLPromotionEntity *)promotionEntity presentGuestlistInvitationInterfaceOnController:(UIViewController *)controller{
    [self presentGuestlistInvitationInterfaceForPromotion:promotionEntity inController:controller];
}

- (void)eventDetailModule:(id<THLEventDetailModuleInterface>)module guestlist:(THLGuestlistEntity *)guestlistEntity guestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)controller {
    [self presentGuestlistReviewInterfaceForGuestlist:guestlistEntity withGuestlistInvite:guestlistInviteEntity inController:controller];
}

- (void)dismissEventDetailWireframe {
    _eventDetailWireframe = nil;
}

#pragma mark - THLGuestlistInvitationModuleDelegate
- (void)dismissGuestlistInvitationWireframe {
    _guestlistInvitationWireframe = nil;
}


@end
