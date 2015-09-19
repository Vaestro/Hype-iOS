//
//  THLLoginInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLoginInteractor.h"
#import "THLUserLoginServiceInterface.h"

@implementation THLLoginInteractor
- (instancetype)initWithLoginService:(id<THLUserLoginServiceInterface>)loginService {
	if (self = [super init]) {
		_loginService = loginService;
	}
	return self;
}

- (void)login {
	[[_loginService loginUser] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
		[_delegate interactor:self didLoginUser:task.result error:task.error];
		return nil;
	}];
}

@end
