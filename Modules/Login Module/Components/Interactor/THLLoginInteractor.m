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
	[[_dataManager login] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
		_user = task.result;
		[_delegate interactor:self didLoginUser:task.error];
		return nil;
	}];
}

- (void)addFacebookInformation {
    [[_dataManager getFacebookInformation] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        NSDictionary *userDictionary = task.result;
        _user.firstName = userDictionary[@"first_name"];
        _user.lastName = userDictionary[@"last_name"];
        _user.sex = ([userDictionary[@"gender"] isEqualToString:@"male"]) ? THLSexMale : THLSexFemale;
        _user.fbBirthday = [[[YLMoment alloc] initWithDateAsString:userDictionary[@"birthday"]] date];
        _user.email = userDictionary[@"email"];
        _user.fbId = userDictionary[@"id"];
        _user.location = userDictionary[@"location"];
        _user.fbVerified = userDictionary[@"verified"];
        _user.type = THLUserTypeGuest;
        [[_user saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *saveTask) {
            [_delegate interactor:self didAddFacebookInformation:saveTask.error];
            return nil;
        }];
        return nil;
    }];
}

- (void)addVerifiedPhoneNumber:(NSString *)phoneNumber {
	_user.phoneNumber = phoneNumber;
	[[_user saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
		[_delegate interactor:self didAddVerifiedPhoneNumber:task.error];
		return nil;
	}];
}

- (void)addProfileImage:(UIImage *)profileImage {
	PFFile *profileImageFile = [self profileImageFileForUser:_user withImage:profileImage];
	_user.image = profileImageFile;
	[[_user saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *task) {
		[_delegate interactor:self didAddProfileImage:task.error];
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

@end
