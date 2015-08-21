//
//  THLParsePromotion.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParsePromotion.h"
#import "THLParseUser.h"
#import "THLParseEvent.h"

@implementation THLParsePromotion
@dynamic time;
@dynamic maleRatio;
@dynamic femaleRatio;
@dynamic host;
@dynamic event;
@dynamic eventId;

+ (void)load {
	[self registerSubclass];
}

+ (NSString *)parseClassName {
	return @"Promotion";
}

@end
