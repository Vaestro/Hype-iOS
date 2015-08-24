//
//  THLEvent.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEvent.h"

@implementation THLEvent
- (BOOL)isEquivalentTo:(THLEntity *)cmpEntity {
	if ([super isEquivalentTo:cmpEntity]) {
		BOOL equivalent = YES;
		THLEvent *cmpEvent = (THLEvent *)cmpEntity;
		if (![self.date isEqualToDate:cmpEvent.date]) {
			equivalent = NO;
		}

		if (![self.title isEqualToString:cmpEvent.title]) {
			equivalent = NO;
		}

		if (![self.promoImageURL isEqualToString:cmpEvent.promoImageURL]) {
			equivalent = NO;
		}

		if (![self.promoInfo isEqualToString:cmpEvent.promoInfo]) {
			equivalent = NO;
		}

		if (self.maleCover != cmpEvent.maleCover) {
			equivalent = NO;
		}

		if (self.femaleCover != cmpEvent.femaleCover) {
			equivalent = NO;
		}

		if (![self.location isEquivalentTo:cmpEvent.location]) {
			equivalent = NO;
		}
		
		return equivalent;
	}
	return NO;
}

@end
