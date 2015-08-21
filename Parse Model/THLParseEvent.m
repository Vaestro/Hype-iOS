//
//  THLParseEvent.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseEvent.h"
#import "THLParseLocation.h"

@implementation THLParseEvent
@dynamic date;
@dynamic maleCoverCharge;
@dynamic femaleCoverCharge;
@dynamic title;
@dynamic promoInfo;
@dynamic promoImage;
@dynamic location;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"Event";
}
@end
