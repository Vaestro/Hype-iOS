//
//  THLNumberVerificationPresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLNumberVerificationPresenter.h"
#import <DigitsKit/DigitsKit.h>
#import "THLAppearanceConstants.h"

@implementation THLNumberVerificationPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLNumberVerificationWireframe *)wireframe {
	if (self = [super init]) {
		_wireframe = wireframe;
	}
	return self;
}

- (void)presentNumberVerificationInterfaceInWindow:(UIWindow *)window {
	WEAKSELF();
	[[Digits sharedInstance] authenticateWithDigitsAppearance:[self newDigitsAppearance] viewController:window.rootViewController title:NSLocalizedString(@"Number Verification", nil) completion:^(DGTSession *session, NSError *error) {
		if (error) {
			[WSELF handleNumberVerificationFailure:error];
		} else {
			[WSELF handleNumberVerificationSuccess:session];
		}
	}];
}
#pragma mark - Logic
- (void)handleNumberVerificationSuccess:(DGTSession *)session {
	NSString *phoneNumber = session.phoneNumber;
	[self.moduleDelegate numberVerificationModule:self didVerifyNumber:phoneNumber];
}

- (void)handleNumberVerificationFailure:(NSError *)error {
	[self.moduleDelegate numberVerificationModule:self didFailToVerifyNumber:error];
}

#pragma mark - Construction
- (DGTAppearance *)newDigitsAppearance {
	DGTAppearance *appearance = [DGTAppearance new];
	appearance.backgroundColor = kTHLUndefColor;
	appearance.accentColor = kTHLUndefTextColor;
	appearance.logoImage = [UIImage imageNamed:@"HypeList Icon"];
	return appearance;
}
@end
