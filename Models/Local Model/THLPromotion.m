//
//  THLPromotion.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLPromotion.h"
#import "THLEvent.h"
#import "THLLocation.h"

@implementation THLPromotion
- (BOOL)updateWith:(THLEntity *)newEntity {
	BOOL didUpdate = NO;
	if ([self shouldUpdateWith:newEntity]) {
		THLPromotion *newPromotion = (THLPromotion *)newEntity;
		if (![self.time isEqualToDate:newPromotion.time]) {
			self.time = newPromotion.time;
			didUpdate = YES;
		}

		if (self.maleRatio != newPromotion.maleRatio) {
			self.maleRatio = newPromotion.maleRatio;
			didUpdate = YES;
		}

		if (self.femaleRatio != newPromotion.femaleRatio) {
			self.femaleRatio = newPromotion.femaleRatio;
			didUpdate = YES;
		}

		if (![self.event isEquivalentTo:newPromotion.event]) {
			self.event = newPromotion.event;
			didUpdate = YES;
		}
	}
	return didUpdate;
}
@end
