//
//  THLGuestFlowWireframe.h
//  Hypelist2point0
//
//  Created by Edgar Li on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEventEntity;

@protocol THLGuestFlowDependencyManager;
@interface THLGuestFlowWireframe : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLGuestFlowDependencyManager> dependencyManager;
- (instancetype)initWithDependencyManager:(id<THLGuestFlowDependencyManager>)dependencyManager;

- (void)presentGuestFlowInWindow:(UIWindow *)window;
- (void)presentGuestFlowInWindow:(UIWindow *)window forEventDetail:(THLEventEntity *)eventEntity;
@end
