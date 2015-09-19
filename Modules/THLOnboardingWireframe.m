//
//  THLOnboardingWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLOnboardingWireframe.h"
#import "THLFacebookPictureModuleInterface.h"
#import "THLNumberVerificationModuleInterface.h"

@interface THLOnboardingWireframe()
<THLNumberVerificationModuleDelegate,
THLFacebookPictureModuleDelegate>

@end

@implementation THLOnboardingWireframe
@synthesize moduleDelegate;
- (instancetype)initWithFacebookPictureModule:(id<THLFacebookPictureModuleInterface>)facebookPictureModule
					 numberVerificationModule:(id<THLNumberVerificationModuleInterface>)numberVerificationModule {
	if (self = [super init]) {
		_facebookPictureModule = facebookPictureModule;
		_facebookPictureModule.moduleDelegate = self;

		_numberVerificationModule = numberVerificationModule;
		_numberVerificationModule.moduleDelegate = self;

	}
	return self;
}

#pragma mark - THLNumberVerificationModuleDelegate
- (void)numberVerificationModule:(id<THLNumberVerificationModuleInterface>)module didFailToVerifyNumber:(NSError *)error {

}

- (void)numberVerificationModule:(id<THLNumberVerificationModuleInterface>)module didVerifyNumber:(NSString *)number {

}
#pragma mark - THLFacebookPictureModuleDelegate
- (void)facebookPictureModule:(id<THLFacebookPictureModuleInterface>)module didSelectImage:(UIImage *)image {

}
@end
