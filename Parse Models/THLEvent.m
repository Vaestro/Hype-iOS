//
//  THLEvent.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEvent.h"

@implementation THLEvent
@dynamic date;
@dynamic location;
@dynamic title;
@dynamic promoInfo;
@dynamic promoImage;
@dynamic admissionOptions;
@dynamic creditsPayout;
@dynamic ageRequirement;
@dynamic featured;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"Event";
}

@end
