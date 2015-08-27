//
//  THLMasterWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLWireframeFactory;

@interface THLMasterWireframe : NSObject
@property (nonatomic, weak) id<THLWireframeFactory> factory;

- (instancetype)initWithFactory:(id<THLWireframeFactory>)factory NS_DESIGNATED_INITIALIZER;
- (void)presentAppInWindow:(UIWindow *)window;
@end
