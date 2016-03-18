//
//  THLLoginInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLoginInteractor.h"
#import "THLLoginDataManager.h"
#import "THLUser.h"
#import "THLUserManager.h"
#import "YLMoment.h"
#import "THLUserDataWorker.h"

@interface THLLoginInteractor()
@end

@implementation THLLoginInteractor
- (instancetype)initWithDataManager:(THLLoginDataManager *)dataManager
						userManager:(THLUserManager *)userManager {
	if (self = [super init]) {
		_dataManager = dataManager;
		_userManager = userManager;
	}
	return self;
}

- (void)setDelegate:(id<THLLoginInteractorDelegate>)delegate {
	_delegate = delegate;
	[self checkForExistingUser];
}

- (void)checkForExistingUser {
	if ([THLUserManager userLoggedIn]) {
		[_delegate interactor:self didLoginUser:nil];
	}
}

- (BOOL)shouldLogin {
	return _user == nil;
}

- (BOOL)shouldAddFacebookInformation {
    return _user.fbId == nil;
}

- (BOOL)shouldVerifyPhoneNumber {
	return _user.phoneNumber == nil || [_user.phoneNumber isEqualToString:@""];
}

- (BOOL)shouldVerifyEmail {
    return _user.email == nil || [_user.email isEqualToString:@""];
}

- (BOOL)shouldPickProfileImage {
	return _user.image == nil;
}

- (void)login {
    WEAKSELF();
	[[_dataManager login] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
		WSELF.user = task.result;
		[WSELF.delegate interactor:WSELF didLoginUser:task.error];
		return nil;
	}];
}

- (void)addFacebookInformation {
    WEAKSELF();
    [[_dataManager getFacebookInformation] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        NSDictionary *userDictionary = task.result;
        [WSELF user].fbId = userDictionary[@"id"];
        [WSELF user].firstName = userDictionary[@"first_name"];
        [WSELF user].lastName = userDictionary[@"last_name"];
        [WSELF user].email = userDictionary[@"email"];
        [WSELF user].sex = ([userDictionary[@"gender"] isEqualToString:@"male"]) ? THLSexMale : THLSexFemale;
//TODO: Add Location and Birthday upon Facebook Approval
//        [WSELF user].fbBirthday = [[[YLMoment alloc] initWithDateAsString:userDictionary[@"birthday"]] date];
//        [WSELF user].location = userDictionary[@"location"];
        if (userDictionary[@"verified"]) {
            [WSELF user].fbVerified = TRUE;
        }
        else {
            [WSELF user].fbVerified = FALSE;
        }
        [WSELF user].type = THLUserTypeGuest;
        [[WSELF.user saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *saveTask) {
            [_delegate interactor:WSELF didAddFacebookInformation:saveTask.error];
            return nil;
        }];
        return nil;
    }];
}

- (void)createMixPanelUserProfile {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    // mixpanel identify: must be called before
    // people properties can be set
    NSString *userSex;
    if (self.user.sex == THLSexMale) {
        userSex = @"Male";
    } else if (self.user.sex == THLSexFemale) {
        userSex = @"Female";
    }
    [mixpanel.people set:@{@"Name": [NSString stringWithFormat:@"%@ %@", self.user.firstName, self.user.lastName],
                           @"Email": self.user.email,
                           @"Gender": userSex
                           }];
}

- (void)addEmail:(NSString *)email {
    _user.email = email;
    WEAKSELF();
    [[_user saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
        [WSELF.delegate interactor:WSELF didAddEmail:task.error];
        return nil;
    }];
}

- (void)addVerifiedPhoneNumber:(NSString *)phoneNumber {
	_user.phoneNumber = phoneNumber;
    WEAKSELF();
	[[_user saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
		[WSELF.delegate interactor:WSELF didAddVerifiedPhoneNumber:task.error];
		return nil;
	}];
}

- (void)addProfileImage:(UIImage *)profileImage {
    [THLUserDataWorker addProfileImage:profileImage forUser:_user delegate:_delegate];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}
@end
