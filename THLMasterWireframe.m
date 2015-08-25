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

@interface THLMasterWireframe()
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
	THLEventDiscoveryWireframe *eventDiscWireframe = [self newEventDiscoveryWireframe];
	self.currentWireframe = eventDiscWireframe;
	[eventDiscWireframe presentEventDiscoveryInterfaceInWindow:window];
}

- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe {
	THLEventDiscoveryWireframe *wireframe = [_factory newEventDiscoveryWireframe];
	return wireframe;
}

@end
