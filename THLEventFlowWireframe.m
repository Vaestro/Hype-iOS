//
//  THLEventFlowWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventFlowWireframe.h"
#import "THLEventDetailWireframe.h"
#import "THLEventDiscoveryWireframe.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLEventFlowDependencyManager.h"

@interface THLEventFlowWireframe()
<
THLEventDiscoveryModuleDelegate,
THLEventDetailModuleDelegate,
THLGuestlistInvitationModuleDelegate
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) THLEventDiscoveryWireframe *eventDiscoveryWireframe;
@property (nonatomic, strong) THLEventDetailWireframe  *eventDetailWireframe;
@property (nonatomic, strong) THLGuestlistInvitationWireframe *guestlistInvitationWireframe;
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

- (void)presentGuestlistInvitationInterface {
	_guestlistInvitationWireframe = [_dependencyManager newGuestlistInvitationWireframe];
    [_guestlistInvitationWireframe.moduleInterface setModuleDelegate:self];
    [_guestlistInvitationWireframe.moduleInterface presentGuestlistInvitationInterfaceForGuestlist:@"1" inWindow:_window];
}

- (void)presentGuestlistInvitationInterfaceInController:(UIViewController *)controller {
	_guestlistInvitationWireframe = [_dependencyManager newGuestlistInvitationWireframe];
	[_guestlistInvitationWireframe.moduleInterface setModuleDelegate:self];
	[_guestlistInvitationWireframe.moduleInterface presentGuestlistInvitationInterfaceForGuestlist:@"1" inController:controller];
}


#pragma mark - THLEventDiscoveryModuleDelegate
- (void)eventDiscoveryModule:(id<THLEventDiscoveryModuleInterface>)module userDidSelectEventEntity:(THLEventEntity *)eventEntity {
	[self presentEventDetailInterfaceForEvent:eventEntity];
}

- (void)eventDetailModule:(id<THLEventDetailModuleInterface>)module presentGuestlistInvitationInterfaceOnController:(UIViewController *)controller{
//    [self presentGuestlistInvitationInterface]; Bad
	[self presentGuestlistInvitationInterfaceInController:controller];
}

#pragma mark - THLEventDetailModuleDelegate
//None




@end
