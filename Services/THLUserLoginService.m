//
//  THLUserLoginService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLUserLoginService.h"
#import "THLParseModule.h"

@implementation THLUserLoginService
- (BFTask *)loginUser {
	return [[THLParseLogin loginWithFacebook] continueWithSuccessBlock:^id(BFTask *task) {
		THLParseUser *user = task.result;
		return [user map];
	}];
}
@end
