//
//  THLGuestFlowWireframe.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLHostFlowModuleInterface.h"
@class THLEventEntity;

@protocol THLHostFlowDependencyManager;
@interface THLHostFlowWireframe : NSObject<THLHostFlowModuleInterface>
@property (nonatomic, readonly, weak) id<THLHostFlowModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLHostFlowDependencyManager> dependencyManager;
- (instancetype)initWithDependencyManager:(id<THLHostFlowDependencyManager>)dependencyManager;
@end
