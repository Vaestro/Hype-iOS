//
//  THLLocation.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLocation.h"
#import "THLEventEntity.h"

@implementation THLLocation
@dynamic image;
@dynamic name;
@dynamic info;
@dynamic address;
@dynamic city;
@dynamic stateCode;
@dynamic zipcode;
@dynamic neighborhood;
@dynamic coordinate;
@dynamic musicTypes;
@dynamic attireRequirement;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"Location";
}

- (NSString *)fullAddress {
	return @"FULL ADDRESS!";
}
@end
