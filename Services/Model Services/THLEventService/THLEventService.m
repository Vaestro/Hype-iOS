//
//  THLEventService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventService.h"
#import "THLParseQueryFactory.h"

@implementation THLEventService
- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory {
	if (self = [super init]) {
		_queryFactory = queryFactory;
	}
	return self;
}

- (BFTask *)fetchEventsFrom:(NSDate *)startDate to:(NSDate *)endDate {
	return [[_queryFactory queryForEventsStartingOn:startDate endingOn:endDate] findObjectsInBackground];
}

@end
