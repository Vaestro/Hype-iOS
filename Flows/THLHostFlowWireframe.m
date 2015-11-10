//
//  THLHostFlowWireframe.m
//  Hypelist2point0
//
//  Created by Edgar Li on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLHostFlowDependencyManager.h"

#import "THLHostFlowWireframe.h"
#import "THLEventDiscoveryWireframe.h"
#import "THLEventHostingWireframe.h"
#import "THLGuestlistReviewWireframe.h"

@interface THLHostFlowWireframe()
<
THLEventDiscoveryModuleDelegate,
THLEventHostingModuleDelegate,
THLGuestlistReviewModuleDelegate
>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) id currentWireframe;
@property (nonatomic, strong) THLEventDiscoveryWireframe *eventDiscoveryWireframe;
@property (nonatomic, strong) THLEventHostingWireframe  *eventHostingWireframe;
@property (nonatomic, strong) THLGuestlistReviewWireframe *guestlistReviewWireframe;
@end

@implementation THLHostFlowWireframe
- (instancetype)initWithDependencyManager:(id<THLHostFlowDependencyManager>)dependencyManager {
    if (self = [super init]) {
        _dependencyManager = dependencyManager;
    }
    return self;
}

#pragma mark - Routing
- (void)presentHostFlowInWindow:(UIWindow *)window {
    _window = window;
    [self presentEventDiscoveryInterface];
}
//
//- (void)presentHostFlowInWindow:(UIWindow *)window forEventHosting:(THLEventEntity *)eventEntity {
//    /**
//     *  Prevents popup notification from instantiating another event detail module if one is already instantiated
//     */
//    if (_currentWireframe != _eventHostingWireframe) {
//        _window = window;
//        [self presentEventHostingInterfaceForEvent:eventEntity];
//    }
//}

- (void)presentEventDiscoveryInterface {
    _eventDiscoveryWireframe = [_dependencyManager newEventDiscoveryWireframe];
    _currentWireframe = _eventDiscoveryWireframe;
    [_eventDiscoveryWireframe.moduleInterface setModuleDelegate:self];
    [_eventDiscoveryWireframe.moduleInterface presentEventDiscoveryInterfaceInWindow:_window];
}

- (void)presentEventHostingInterfaceForEvent:(THLEventEntity *)eventEntity {
    _eventHostingWireframe = [_dependencyManager newEventHostingWireframe];
    _currentWireframe = _eventHostingWireframe;
    [_eventHostingWireframe.moduleInterface setModuleDelegate:self];
    [_eventHostingWireframe.moduleInterface presentEventHostingInterfaceForEvent:eventEntity inWindow:_window];
}

- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity inController:(UIViewController *)controller {
    _guestlistReviewWireframe = [_dependencyManager newGuestlistReviewWireframe];
    _currentWireframe = _guestlistReviewWireframe;
    [_guestlistReviewWireframe.moduleInterface setModuleDelegate:self];
    [_guestlistReviewWireframe.moduleInterface presentGuestlistReviewInterfaceForGuestlist:guestlistEntity inController:controller];
}


#pragma mark - THLEventDiscoveryModuleDelegate
- (void)eventDiscoveryModule:(id<THLEventDiscoveryModuleInterface>)module userDidSelectEventEntity:(THLEventEntity *)eventEntity {
    [self presentEventHostingInterfaceForEvent:eventEntity];
}

#pragma mark - THLEventHostingModuleDelegate
- (void)eventHostingModule:(id<THLEventHostingModuleInterface>)module userDidSelectGuestlistEntity:(THLGuestlistEntity *)guestlistEntity presentGuestlistReviewInterfaceOnController:(UIViewController *)controller {
    [self presentGuestlistReviewInterfaceForGuestlist:guestlistEntity inController:controller];
}

- (void)dismissEventHostingWireframe {
    _eventHostingWireframe = nil;
}

#pragma mark - THLGuestlistReviewModuleDelegate
- (void)dismissGuestlistReviewWireframe {
    _guestlistReviewWireframe = nil;
}

@end