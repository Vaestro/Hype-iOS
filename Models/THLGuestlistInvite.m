//
//  THLGuestlistInvite.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInvite.h"

@implementation THLGuestlistInvite
@dynamic sender;
@dynamic recipient;
@dynamic guestlist;
@dynamic response;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"GuestlistInvite";
}
@end
