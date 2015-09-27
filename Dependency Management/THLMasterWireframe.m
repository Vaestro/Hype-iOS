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
#import "THLEventFlowWireframe.h"
#import "THLPromotionSelectionWireframe.h"

//Delegates
#import "THLLoginModuleDelegate.h"
#import "THLPromotionSelectionModuleDelegate.h"


@interface THLMasterWireframe()
<
THLLoginModuleDelegate,
        THLPromotionSelectionModuleDelegate
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) id currentWireframe;
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
	[self presentLoginInterface];
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

#pragma mark - THLLoginModuleDelegate
- (void)loginModule:(id<THLLoginModuleInterface>)module didLoginUser:(NSError *)error {
	if (!error) {
		[self presentEventFlow];
	}
}

#pragma mark - THLPromotionSelectionModuleDelegate
- (void)promotionSelectionModule:(id<THLPromotionSelectionModuleInterface>)module didSelectPromotion:(THLPromotionEntity *)promotionEntity {
	
}
@end
