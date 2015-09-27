//
//  THLMasterWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLDependencyManager;

@interface THLMasterWireframe : NSObject
#pragma mark - Dependencies
@property (nonatomic, weak, readonly) THLDependencyManager *dependencyManager;
- (instancetype)initWithDependencyManager:(THLDependencyManager *)dependencyManager;

- (void)presentAppInWindow:(UIWindow *)window;
@end
