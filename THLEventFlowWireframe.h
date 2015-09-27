//
//  THLEventFlowWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLEventFlowDependencyManager;
@interface THLEventFlowWireframe : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLEventFlowDependencyManager> dependencyManager;
- (instancetype)initWithDependencyManager:(id<THLEventFlowDependencyManager>)dependencyManager;

- (void)presentEventFlowInWindow:(UIWindow *)window;
@end
