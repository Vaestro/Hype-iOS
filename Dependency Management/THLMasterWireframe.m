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
#import "THLPromotionSelectionWireframe.h"
#import "THLGuestlistInvitationWireframe.h"

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
@property (nonatomic, strong) id currentWireframe;
@property (nonatomic, strong) THLSessionService *sessionService;
@end

@implementation THLMasterWireframe
- (instancetype)initWithDependencyManager:(THLDependencyManager *)dependencyManager {
	if (self = [super init]) {
        _dependencyManager = dependencyManager;
        // Initialize Session
        _sessionService = [[THLSessionService alloc] init];
	}
	return self;
}

- (void)presentAppInWindow:(UIWindow *)window {
	_window = window;
    
    if ([_sessionService isUserCached]) {
        [self presentEventFlow];
//    [self presentGuestlistInvitationInterface];
    }else {
        [self presentLoginInterface];
    }
	
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
