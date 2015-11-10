//
//  THLGuestFlowWireframe.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEventEntity;

@protocol THLHostFlowDependencyManager;
@interface THLHostFlowWireframe : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLHostFlowDependencyManager> dependencyManager;
- (instancetype)initWithDependencyManager:(id<THLHostFlowDependencyManager>)dependencyManager;

- (void)presentHostFlowInWindow:(UIWindow *)window;
//- (void)presentHostFlowInWindow:(UIWindow *)window forEventDetail:(THLEventEntity *)eventEntity;
@end
