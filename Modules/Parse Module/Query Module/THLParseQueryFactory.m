//
//  THLParseQueryFactory.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseQueryFactory.h"

#import "THLParseModels.h"
#import "PFObject+MatchingQuery.h"

@implementation THLParseQueryFactory
#pragma mark - Event Queries
+ (PFQuery *)queryForEventsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate {
	PFQuery *query = [self baseEventQuery];
	[query whereKey:@"date" greaterThanOrEqualTo:startDate];
	[query whereKey:@"date" lessThanOrEqualTo:endDate];
	[query whereKey:@"objectId" matchesKey:@"eventId" inQuery:[self basePromotionQuery]];
	return query;
}

+ (PFQuery *)queryForPromotionsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate {
	PFQuery *eventQuery = [self baseEventQuery];
	[eventQuery whereKey:@"date" greaterThanOrEqualTo:startDate];
	[eventQuery whereKey:@"date" lessThanOrEqualTo:endDate];

	PFQuery *query = [self basePromotionQuery];
	[query whereKey:@"event" matchesQuery:eventQuery];
	return query;

}

+ (PFQuery *)queryForPromotionsForEvent:(THLParseEvent *)event {
	PFQuery *query = [self basePromotionQuery];
	[query whereKey:@"event" matchesQuery:[event matchingQuery]];
	return query;
}

#pragma mark - Class Queries
/**
 *  Generic query for THLParsePromotion.
 *	Includes: host, event
 */
+ (PFQuery *)basePromotionQuery {
	PFQuery *query = [THLParsePromotion query];
	[query includeKey:@"host"];
	[query includeKey:@"event"];
	return query;
}

/**
 *  Generic query for THLParseUser.
 *	Includes: (none)
 */
+ (PFQuery *)baseUserQuery {
	PFQuery *query = [THLParseUser query];
	return query;
}

/**
 *  Generic query for THLParseEvent
 *	Includes: location
 */
+ (PFQuery *)baseEventQuery {
	PFQuery *query = [THLParseEvent query];
	[query includeKey:@"location"];
	return query;
}

/**
 *  Generic query for THLParseLocation
 *	Includes: (none)
 */
+ (PFQuery *)baseLocationQuery {
	PFQuery *query = [THLParseLocation query];
	return query;
}
@end
