//
//  THLLoginWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLLoginModuleInterface.h"

@class THLUserManager;
@protocol THLLoginServiceInterface;
@protocol THLNumberVerificationModuleInterface;
@protocol THLNumberVerificationModuleDelegate;
@protocol THLFacebookPictureModuleInterface;
@protocol THLFacebookPictureModuleDelegate;

@interface THLLoginWireframe : NSObject
@property (nonatomic, readonly, weak) id<THLLoginModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLLoginServiceInterface> loginService;
@property (nonatomic, readonly, weak) THLUserManager *userManager;
@property (nonatomic, readonly, weak) id<THLNumberVerificationModuleInterface> numberVerificationModule;
@property (nonatomic, readonly, weak) id<THLFacebookPictureModuleInterface> facebookPictureModule;


- (instancetype)initWithLoginService:(id<THLLoginServiceInterface>)loginService
						 userManager:(THLUserManager *)userManager
			numberVerificationModule:(id<THLNumberVerificationModuleInterface>)numberVerificationModule
			   facebookPictureModule:(id<THLFacebookPictureModuleInterface>)facebookPictureModule;


- (void)presentInterfaceInWindow:(UIWindow *)window;
- (void)presentNumberVerificationInterface:(id<THLNumberVerificationModuleDelegate>)interfaceDelegate;
- (void)presentFacebookPictureInterface:(id<THLFacebookPictureModuleDelegate>)interfaceDelegate;
@end
