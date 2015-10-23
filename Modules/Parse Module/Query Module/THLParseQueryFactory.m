//
//  THLParseQueryFactory.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseQueryFactory.h"
#import "PFObject+MatchingQuery.h"
#import "PFQuery.h"
#import "THLLocalModels.h"

@implementation THLParseQueryFactory
#pragma mark - Event Queries
- (PFQuery *)queryForEventsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate {
	PFQuery *query = [self baseEventQuery];
	[query whereKey:@"date" greaterThanOrEqualTo:startDate];
	[query whereKey:@"date" lessThanOrEqualTo:endDate];
	[query whereKey:@"objectId" matchesKey:@"eventId" inQuery:[self basePromotionQuery]];
	return query;
}

- (PFQuery *)queryForPromotionsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate {
	PFQuery *eventQuery = [self baseEventQuery];
	[eventQuery whereKey:@"date" greaterThanOrEqualTo:startDate];
	[eventQuery whereKey:@"date" lessThanOrEqualTo:endDate];

	PFQuery *query = [self basePromotionQuery];
	[query whereKey:@"event" matchesQuery:eventQuery];
	return query;
}

- (PFQuery *)queryForPromotionsForEvent:(THLEvent *)event {
	PFQuery *query = [self basePromotionQuery];
	[query whereKey:@"event" matchesQuery:[event matchingQuery]];
	return query;
}

- (PFQuery *)queryForGuestlistForGuest:(THLUser *)guest forEvent:(NSString *)eventId {
    PFQuery *guestlistQuery = [self baseGuestlistQuery];
    [guestlistQuery whereKey:@"owner" matchesQuery:[guest matchingQuery]];
    [guestlistQuery whereKey:@"eventID" equalTo:eventId];
    
    PFQuery *query = [self baseGuestlistQuery];
    [query whereKey:@"guestlist" matchesQuery:guestlistQuery];
    return query;
}

#pragma mark - Class Queries
/**
 *  Generic query for THLPromotion.
 *	Includes: host, event
 */
- (PFQuery *)basePromotionQuery {
	PFQuery *query = [THLPromotion query];
	[query includeKey:@"host"];
	[query includeKey:@"event"];
	return query;
}

/**
 *  Generic query for THLUser.
 *	Includes: (none)
 */
- (PFQuery *)baseUserQuery {
	PFQuery *query = [THLUser query];
	return query;
}

/**
 *  Generic query for THLEvent
 *	Includes: location
 */
- (PFQuery *)baseEventQuery {
	PFQuery *query = [THLEvent query];
	[query includeKey:@"location"];
	return query;
}

/**
 *  Generic query for THLGuestlist
 *	Includes: guest, promotion
 */
- (PFQuery *)baseGuestlistQuery {
    PFQuery *query = [THLGuestlist query];
    [query includeKey:@"guest"];
    [query includeKey:@"promotion"];
    return query;
}

/**
 *  Generic query for THLParseLocation
 *	Includes: (none)
 */
- (PFQuery *)baseLocationQuery {
	PFQuery *query = [THLLocation query];
	return query;
}
@end
