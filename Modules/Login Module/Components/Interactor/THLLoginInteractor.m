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

@interface THLLoginInteractor()
@property (nonatomic, strong) THLUser *user;
@end

@implementation THLLoginInteractor
- (instancetype)initWithDataManager:(THLLoginDataManager *)dataManager {
	if (self = [super init]) {
		_dataManager = dataManager;
	}
	return self;
}

- (BOOL)shouldLogin {
	return _user == nil;
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
