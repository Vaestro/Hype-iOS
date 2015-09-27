//
//  THLLoginWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLLoginModuleInterface.h"

@protocol THLLoginServiceInterface;
@protocol THLNumberVerificationModuleInterface;
@protocol THLNumberVerificationModuleDelegate;
@protocol THLFacebookPictureModuleInterface;
@protocol THLFacebookPictureModuleDelegate;

@interface THLLoginWireframe : NSObject
@property (nonatomic, readonly) id<THLLoginModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly) id<THLLoginServiceInterface> loginService;
@property (nonatomic, readonly) id<THLNumberVerificationModuleInterface> numberVerificationModule;
@property (nonatomic, readonly) id<THLFacebookPictureModuleInterface> facebookPictureModule;
- (instancetype)initWithLoginService:(id<THLLoginServiceInterface>)loginService
			numberVerificationModule:(id<THLNumberVerificationModuleInterface>)numberVerificationModule
			   facebookPictureModule:(id<THLFacebookPictureModuleInterface>)facebookPictureModule;


- (void)presentInterfaceInWindow:(UIWindow *)window;
- (void)presentNumberVerificationInterface:(id<THLNumberVerificationModuleDelegate>)interfaceDelegate;
- (void)presentFacebookPictureInterface:(id<THLFacebookPictureModuleDelegate>)interfaceDelegate;
@end
