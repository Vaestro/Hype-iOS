//
//  THLUserManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserManager.h"
#import "THLUser.h"

@implementation THLUserManager
- (instancetype)init {
	if (self = [super init]) {

	}
	return self;
}

#pragma mark - Properties
- (THLUser *)currentUser {
	return [THLUser currentUser];
}

- (BOOL)userLoggedIn {
	return self.currentUser != nil;
}

@end
