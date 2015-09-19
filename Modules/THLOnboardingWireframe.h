//
//  THLOnboardingWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLOnboardingModuleInterface.h"
@protocol THLFacebookPictureModuleInterface;
@protocol THLNumberVerificationModuleInterface;

@interface THLOnboardingWireframe : NSObject<THLOnboardingModuleInterface>
@property (nonatomic, readonly) id<THLFacebookPictureModuleInterface> facebookPictureModule;
@property (nonatomic, retain) id<THLNumberVerificationModuleInterface> numberVerificationModule;

- (instancetype)initWithFacebookPictureModule:(id<THLFacebookPictureModuleInterface>)facebookPictureModule
					 numberVerificationModule:(id<THLNumberVerificationModuleInterface>)numberVerificationModule;
@end
