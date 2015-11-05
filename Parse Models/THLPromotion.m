//
//  THLPromotion.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLPromotion.h"

@implementation THLPromotion
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
