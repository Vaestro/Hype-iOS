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
@dynamic maleCoverCharge;
@dynamic femaleCoverCharge;
@dynamic title;
@dynamic promoInfo;
@dynamic promoImage;
@dynamic location;
@dynamic creditsPayout;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"Event";
}

@end
