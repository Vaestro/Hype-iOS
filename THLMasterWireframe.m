//
//  THLMasterWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLMasterWireframe.h"
#import "THLEventDiscoveryWireframe.h"
#import "THLDependencyManager.h"
#import "THLEventDetailWireframe.h"
#import "THLEventDiscoveryModuleDelegate.h"

@interface THLMasterWireframe()
<
THLEventDetailModuleDelegate,
THLEventDiscoveryModuleDelegate
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
	[self presentEventDiscoveryInterface];
}

#pragma mark - Routing
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

#pragma mark - THLEventDiscoveryModuleDelegate
- (void)eventDiscoveryModule:(id<THLEventDiscoveryModuleInterface>)module
		  userDidSelectEvent:(THLEvent *)event {
	[self presentEventDetailInterfaceForEvent:event];
}

#pragma mark - THLEventDetailModuleDelegate
//None

@end
