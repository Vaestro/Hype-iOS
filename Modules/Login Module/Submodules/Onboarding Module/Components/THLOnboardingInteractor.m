//
//  THLOnboardingInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/19/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLOnboardingInteractor.h"

@implementation THLOnboardingInteractor

- (void)updateUser:(THLUser *)user withPhoneNumber:(NSString *)phoneNumber {
	[_delegate interactor:self didUpdateUser:user withPhoneNumber:phoneNumber error:nil];
}

- (void)updateUser:(THLUser *)user withProfileImage:(UIImage *)profileImage {
	[_delegate interactor:self didUpdateUser:user withProfileImage:profileImage error:nil];
}

@end
