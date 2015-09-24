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

//Wireframes
#import "THLLoginWireframe.h"
#import "THLOnboardingWireframe.h"
#import "THLEventDiscoveryWireframe.h"
#import "THLEventDetailWireframe.h"
#import "THLChooseHostWireframe.h"

//Delegates
#import "THLLoginModuleDelegate.h"
#import "THLOnboardingModuleDelegate.h"
#import "THLEventDetailModuleDelegate.h"
#import "THLEventDiscoveryModuleDelegate.h"
#import "THLChooseHostModuleDelegate.h"

@interface THLMasterWireframe()
<
THLLoginModuleDelegate,
THLOnboardingModuleDelegate,
THLEventDetailModuleDelegate,
THLEventDiscoveryModuleDelegate,
THLChooseHostModuleDelegate
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) id currentWireframe;
@end

@implementation THLMasterWireframe
- (instancetype)initWithFactory:(id<THLWireframeFactory>)factory {
	if (self = [super init]) {
		_factory = factory;
	}
	return self;
}

- (void)presentAppInWindow:(UIWindow *)window {
	_window = window;
	[self presentLoginInterface];
}

#pragma mark - Routing
- (void)presentLoginInterface {
	THLLoginWireframe *loginWireframe = [_factory newLoginWireframe];
	_currentWireframe = loginWireframe;
	[loginWireframe.moduleInterface setModuleDelegate:self];
	[loginWireframe.moduleInterface presentLoginModuleInterfaceInWindow:_window];
}

- (void)presentOnboardingInterfaceForUser:(THLUser *)user {
	THLOnboardingWireframe *onboardingWireframe = [_factory newOnboardingWireframe];
	_currentWireframe = onboardingWireframe;
	[onboardingWireframe.moduleInterface setModuleDelegate:self];
	[onboardingWireframe.moduleInterface presentInterfaceForOnboardingUser:user inWindow:_window];
}

- (void)presentEventDiscoveryInterface {
	THLEventDiscoveryWireframe *eventDiscWireframe = [_factory newEventDiscoveryWireframe];
	_currentWireframe = eventDiscWireframe;
	[eventDiscWireframe.moduleInterface setModuleDelegate:self];
	[eventDiscWireframe.moduleInterface presentEventDiscoveryInterfaceInWindow:_window];
}

- (void)presentEventDetailInterfaceForEvent:(THLEvent *)event {
	THLEventDetailWireframe *eventDetailWireframe = [_factory newEventDetailWireframe];
	_currentWireframe = eventDetailWireframe;
	[eventDetailWireframe.moduleInterface setModuleDelegate:self];
	[eventDetailWireframe.moduleInterface presentEventDetailInterfaceForEvent:event inWindow:_window];
}

#pragma mark - THLLoginModuleDelegate
- (void)loginModule:(id<THLLoginModuleInterface>)module didLoginUser:(THLUser *)user {
	[self presentOnboardingInterfaceForUser:user];
}

- (void)loginModule:(id<THLLoginModuleInterface>)module didFailToLoginWithError:(NSError *)error  {
	[self presentLoginInterface];
}

#pragma mark - THLOnboardingModuleDelegate
- (void)onboardingModule:(id<THLOnboardingModuleInterface>)module didOnboardUser:(THLUser *)user {
	[self presentEventDiscoveryInterface];
}

#pragma mark - THLEventDiscoveryModuleDelegate
- (void)eventDiscoveryModule:(id<THLEventDiscoveryModuleInterface>)module
		  userDidSelectEvent:(THLEvent *)event {
	[self presentEventDetailInterfaceForEvent:event];
}

#pragma mark - THLEventDetailModuleDelegate
//None

#pragma mark - THLChooseHostModuleDelegate
- (void)chooseHostModule:(id<THLChooseHostModuleInterface>)module didSelectHost:(THLPromotion *)promotion {
	
}
@end
