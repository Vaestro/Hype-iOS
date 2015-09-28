//
//  THLEventDetailWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLEventDetailModuleInterface.h"

@protocol THLLocationServiceInterface;

@interface THLEventDetailWireframe : NSObject
@property (nonatomic, readonly) id<THLEventDetailModuleInterface> moduleInterface;
#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLLocationServiceInterface> locationService;
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService;

- (void)presentInterfaceInWindow:(UIWindow *)window;
- (void)dismissInterface;
@end
