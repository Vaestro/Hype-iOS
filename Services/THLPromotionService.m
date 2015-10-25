//
//  THLPromotionService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPromotionService.h"
#import "THLParseQueryFactory.h"

@implementation THLPromotionService
- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory {
	if (self = [super init]) {
		_queryFactory = queryFactory;
	}
	return self;
}

- (BFTask *)fetchPromotionsForEvent:(NSString *)eventId {
	return [[_queryFactory queryForPromotionsForEvent:eventId] findObjectsInBackground];
}

@end
