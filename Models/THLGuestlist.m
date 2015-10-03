//
//  THLGuestlist.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlist.h"

@implementation THLGuestlist
@dynamic owner;
@dynamic promotion;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"Guestlist";
}

@end
