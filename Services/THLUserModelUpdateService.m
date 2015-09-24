//
//  THLUserModelUpdateService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/21/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserModelUpdateService.h"
#import "THLUser.h"
#import "THLParseModule.h"

@implementation THLUserModelUpdateService
- (BFTask *)updateUser:(THLUser *)user withPhoneNumber:(NSString *)phoneNumber {
	user.phoneNumber = phoneNumber;
	return nil;
}

- (BFTask *)updateUser:(THLUser *)user withProfileImage:(UIImage *)image {
	return nil;
}

@end
