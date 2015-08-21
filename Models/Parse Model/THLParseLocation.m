//
//  THLParseLocation.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseLocation.h"

@implementation THLParseLocation
@dynamic image;
@dynamic name;
@dynamic info;
@dynamic address;
@dynamic city;
@dynamic stateCode;
@dynamic zipcode;
@dynamic neighborhood;
@dynamic coordinate;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"Location";
}
@end
