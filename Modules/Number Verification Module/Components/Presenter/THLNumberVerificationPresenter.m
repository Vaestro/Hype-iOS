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

@interface THLNumberVerificationPresenter ()
@property (nonatomic, strong) DGTAppearance *digitsApperance;

@end

@implementation THLNumberVerificationPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLNumberVerificationWireframe *)wireframe {
	if (self = [super init]) {
		_wireframe = wireframe;
        _digitsApperance = [self newDigitsAppearance];
	}
	return self;
}

- (void)presentNumberVerificationInterfaceInWindow:(UIWindow *)window {
	WEAKSELF();
    STRONGSELF();
    DGTAuthenticationConfiguration *configuration = [DGTAuthenticationConfiguration new];
    [[Digits sharedInstance] logOut];

    configuration.title = NSLocalizedString(@"Number Verification", nil);
    configuration.appearance = _digitsApperance;
	[[Digits sharedInstance] authenticateWithViewController:window.rootViewController configuration:configuration completion:^(DGTSession *session, NSError *error) {
		if (error) {
			[SSELF handleNumberVerificationFailure:error];
		} else {
			[SSELF handleNumberVerificationSuccess:session];
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
	appearance.backgroundColor = kTHLNUIPrimaryBackgroundColor;
	appearance.accentColor = kTHLNUIAccentColor;
	appearance.logoImage = [UIImage imageNamed:@"Hypelist-Icon"];
	return appearance;
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}
@end
