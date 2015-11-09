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

@interface THLLoginInteractor()
@property (nonatomic, strong) THLUser *user;
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
	if ([_userManager userLoggedIn]) {
		[_delegate interactor:self didLoginUser:nil];
	}
}

- (BOOL)shouldLogin {
	return _user == nil;
}

- (BOOL)shouldAddFacebookInformation {
    return _user.firstName == nil;
}

- (BOOL)shouldVerifyPhoneNumber {
	return _user.phoneNumber == nil;
}

- (BOOL)shouldPickProfileImage {
	return _user.image == nil;
}

- (void)login {
    WEAKSELF();
	[[_dataManager login] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
		WSELF.user = task.result;
		[_delegate interactor:WSELF didLoginUser:task.error];
		return nil;
	}];
}

- (void)addFacebookInformation {
    WEAKSELF();
    [[_dataManager getFacebookInformation] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        NSDictionary *userDictionary = task.result;
        [WSELF user].firstName = userDictionary[@"first_name"];
        [WSELF user].lastName = userDictionary[@"last_name"];
        [WSELF user].sex = ([userDictionary[@"gender"] isEqualToString:@"male"]) ? THLSexMale : THLSexFemale;
        [WSELF user].fbBirthday = [[[YLMoment alloc] initWithDateAsString:userDictionary[@"birthday"]] date];
        [WSELF user].email = userDictionary[@"email"];
        [WSELF user].fbId = userDictionary[@"id"];
        [WSELF user].location = userDictionary[@"location"];
        [WSELF user].fbVerified = userDictionary[@"verified"];
        [WSELF user].type = THLUserTypeGuest;
        [[WSELF.user saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *saveTask) {
            [_delegate interactor:WSELF didAddFacebookInformation:saveTask.error];
            return nil;
        }];
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
	PFFile *profileImageFile = [self profileImageFileForUser:_user withImage:profileImage];
	_user.image = profileImageFile;
    WEAKSELF();
	[[_user saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
		[_delegate interactor:WSELF didAddProfileImage:task.error];
		return nil;
	}];
}

#pragma mark - Profile Image Helpers
- (PFFile *)profileImageFileForUser:(THLUser *)user withImage:(UIImage *)image {
	NSData *imageData = UIImagePNGRepresentation(image);
	PFFile *imageFile = [PFFile fileWithName:[self profileImageNameForUser:user] data:imageData];
	return imageFile;
}

- (NSString *)profileImageNameForUser:(THLUser *)user {
	NSArray *nameComponents = @[@"ProfilePicture",
								user.fullName];
	return [nameComponents componentsJoinedByString:@"_"];
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
