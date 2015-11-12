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
    return [_loginService login];
}

- (BFTask *)getFacebookInformation {
    return [_loginService getFacebookUserDictionary];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}

@end
