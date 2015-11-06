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
#import "YLMoment.h"

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
//    [[_loginService getFacebookUserDictionary] continueWithBlock:^id(BFTask *task) {
//        NSDictionary *userDictionary = task.result;
//        currentUser.firstName = userDictionary[kTHLFBSDKFirst_nameKey];
//        currentUser.lastName = userDictionary[kTHLFBSDKLast_nameKey];
//        currentUser.sex = ([userDictionary[kTHLFBSDKGenderKey] isEqualToString:@"male"]) ? THLSexMale : THLSexFemale;
//        currentUser.phoneNumber = [THLUser currentUser].phoneNumber;
//        currentUser.fbBirthday = [[[YLMoment alloc] initWithDateAsString:userDictionary[kTHLFBSDKBirthdayKey]] date];
//        currentUser.email = userDictionary[kTHLFBSDKEmailKey];
//        currentUser.fbId = userDictionary[kTHLFBSDKIdKey];
//        return [currentUser saveInBackground];
//    }];
	return [BFTask taskWithResult:currentUser];
}



@end
