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
@dynamic maleCoverRange;
@dynamic femaleCoverRange;
@dynamic title;
@dynamic promoInfo;
@dynamic promoImage;
@dynamic location;
@dynamic creditsPayout;
@dynamic host;
@dynamic requiresApproval;
@dynamic maleRatio;
@dynamic femaleRatio;
@dynamic chatMessage;


+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"Event";
}

@end
