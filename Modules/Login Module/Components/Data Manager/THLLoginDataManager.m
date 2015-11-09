//
//  THLLoginDataManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLLoginDataManager.h"
#import "THLLoginServiceInterface.h"
#import "THLUser.h"

@implementation THLLoginDataManager
- (instancetype)initWithLoginService:(id<THLLoginServiceInterface>)loginService {
	if (self = [super init]) {
		_loginService = loginService;
	}
	return self;
}

#pragma mark - Interface
- (BFTask *)login {
	THLUser *currentUser = [THLUser currentUser];
	if (!currentUser) {
		return [_loginService login];
	}
	return [BFTask taskWithResult:currentUser];
}

- (BFTask *)getFacebookInformation {
    return [_loginService getFacebookUserDictionary];
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}

@end
