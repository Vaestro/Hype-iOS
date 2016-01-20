//
//  THLGuestFlowWireframe.h
//  Hypelist2point0
//
//  Created by Edgar Li on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestFlowModuleInterface.h"
@class THLEventEntity;

@protocol THLGuestFlowDependencyManager;
@interface THLGuestFlowWireframe : NSObject<THLGuestFlowModuleInterface>
@property (nonatomic, readonly, weak) id<THLGuestFlowModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestFlowDependencyManager> dependencyManager;
- (instancetype)initWithDependencyManager:(id<THLGuestFlowDependencyManager>)dependencyManager;

- (void)configureMasterTabViewControllerAndPresentGuestFlowInWindow:(UIWindow *)window;
- (void)presentGuestFlowInWindow:(UIWindow *)window forEventDetail:(THLEventEntity *)eventEntity;
- (void)showNotificationBadge;

@end
