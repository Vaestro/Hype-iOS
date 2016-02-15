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
@property (nonatomic, readonly) id<THLLoginServiceInterface> loginService;
@property (nonatomic, readonly) THLUserManager *userManager;
@property (nonatomic, readonly) id<THLNumberVerificationModuleInterface> numberVerificationModule;
@property (nonatomic, readonly) id<THLFacebookPictureModuleInterface> facebookPictureModule;


- (instancetype)initWithLoginService:(id<THLLoginServiceInterface>)loginService
						 userManager:(THLUserManager *)userManager
			numberVerificationModule:(id<THLNumberVerificationModuleInterface>)numberVerificationModule
			   facebookPictureModule:(id<THLFacebookPictureModuleInterface>)facebookPictureModule;


- (void)presentOnboardingInterfaceInWindow:(UIWindow *)window;
- (void)presentUserVerificationInterfaceInWindow:(UIWindow *)window;
- (void)presentLoginInterfaceOnViewController:(UIViewController *)viewController;
- (void)presentLoginInterfaceOnNavigationController:(UINavigationController *)navigationController;
- (void)presentNumberVerificationInterface:(id<THLNumberVerificationModuleDelegate>)interfaceDelegate;
- (void)presentFacebookPictureInterface:(id<THLFacebookPictureModuleDelegate>)interfaceDelegate;

- (void)dismissInterface;
- (void)finishLogin;
- (void)finishOnboarding;

@end
