//
//  THLGuestFlowWireframe.m
//  Hypelist2point0
//
//  Created by Edgar Li on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import "THLGuestFlowDependencyManager.h"

#import "THLGuestFlowWireframe.h"

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

@interface THLGuestFlowWireframe()
<
THLEventDiscoveryModuleDelegate,
THLEventDetailModuleDelegate,
THLGuestlistInvitationModuleDelegate,
THLGuestlistReviewModuleDelegate
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) id currentWireframe;
@property (nonatomic, strong) THLEventDiscoveryWireframe *eventDiscoveryWireframe;
@property (nonatomic, strong) THLEventDetailWireframe  *eventDetailWireframe;
@property (nonatomic, strong) THLGuestlistInvitationWireframe *guestlistInvitationWireframe;
@property (nonatomic, strong) THLGuestlistReviewWireframe *guestlistReviewWireframe;
@end

@implementation THLGuestFlowWireframe
- (instancetype)initWithDependencyManager:(id<THLGuestFlowDependencyManager>)dependencyManager {
	if (self = [super init]) {
		_dependencyManager = dependencyManager;
	}
	return self;
}

#pragma mark - Routing
- (void)presentGuestFlowInWindow:(UIWindow *)window {
	_window = window;
	[self presentEventDiscoveryInterface];
}

- (void)presentGuestFlowInWindow:(UIWindow *)window forEventDetail:(THLEventEntity *)eventEntity {
    /**
     *  Prevents popup notification from instantiating another event detail module if one is already instantiated
     */
    if (_currentWireframe != _eventDetailWireframe) {
        _window = window;
        [self presentEventDetailInterfaceForEvent:eventEntity];
    }
}

- (void)presentEventDiscoveryInterface {
	_eventDiscoveryWireframe = [_dependencyManager newEventDiscoveryWireframe];
    _currentWireframe = _eventDiscoveryWireframe;
	[_eventDiscoveryWireframe.moduleInterface setModuleDelegate:self];
	[_eventDiscoveryWireframe.moduleInterface presentEventDiscoveryInterfaceInWindow:_window];
}

- (void)presentEventDetailInterfaceForEvent:(THLEventEntity *)eventEntity {
	_eventDetailWireframe = [_dependencyManager newEventDetailWireframe];
    _currentWireframe = _eventDiscoveryWireframe;
    [_eventDetailWireframe.moduleInterface setModuleDelegate:self];
	[_eventDetailWireframe.moduleInterface presentEventDetailInterfaceForEvent:eventEntity inWindow:_window];
}


- (void)presentGuestlistInvitationInterfaceForPromotion:(THLPromotionEntity *)promotionEntity inController:(UIViewController *)controller {
	_guestlistInvitationWireframe = [_dependencyManager newGuestlistInvitationWireframe];
    _currentWireframe = _eventDiscoveryWireframe;
    [_guestlistInvitationWireframe.moduleInterface setModuleDelegate:self];
	[_guestlistInvitationWireframe.moduleInterface presentGuestlistInvitationInterfaceForPromotion:promotionEntity inController:controller];
}

- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity withGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity inController:(UIViewController *)controller {
    _guestlistReviewWireframe = [_dependencyManager newGuestlistReviewWireframe];
    _currentWireframe = _eventDiscoveryWireframe;
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

#pragma mark - THLGuestlistReviewModuleDelegate
- (void)dismissGuestlistReviewWireframe {
    _guestlistReviewWireframe = nil;
}

@end
