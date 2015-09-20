//
//  THLLoginWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLLoginModuleInterface.h"

@protocol THLUserLoginServiceInterface;

@interface THLLoginWireframe : NSObject
@property (nonatomic, readonly) id<THLUserLoginServiceInterface> loginService;
- (instancetype)initWithLoginService:(id<THLUserLoginServiceInterface>)loginService;

@property (nonatomic, readonly) id<THLLoginModuleInterface> moduleInterface;
- (void)presentInterfaceInWindow:(UIWindow *)window;
@end
