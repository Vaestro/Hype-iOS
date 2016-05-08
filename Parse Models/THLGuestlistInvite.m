//
//  THLGuestlistInvite.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInvite.h"

@implementation THLGuestlistInvite
@dynamic guest;
@dynamic guestlist;
@dynamic guestlistTicket;
@dynamic response;
@dynamic checkInStatus;
@dynamic didOpen;
@dynamic date;
@dynamic invitationCode;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"GuestlistInvite";
}
@end
