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
    THLUser *currentUser = [THLUser currentUser];
    PFQuery *query = [self baseEventQuery];
    [query whereKey:@"date" greaterThanOrEqualTo:startDate];
    [query whereKey:@"date" lessThanOrEqualTo:endDate];
    /**
     *  If User is a Guest fetch all events. If User is Host, only fetch Events that they have a promotion for.
     */
    if (currentUser.type == THLUserTypeGuest) {
        [query whereKey:@"objectId" matchesKey:@"eventId" inQuery:[self basePromotionQuery]];
    }
    else if (currentUser.type == THLUserTypeHost) {
        PFQuery *promotionQuery = [self basePromotionQuery];
        [promotionQuery whereKey:@"host" equalTo:[THLUser currentUser]];
        [query whereKey:@"objectId" matchesKey:@"eventId" inQuery:promotionQuery];
    }

	return query;
}

#pragma mark - Promotion Queries
- (PFQuery *)queryForPromotionsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate {
	PFQuery *eventQuery = [self baseEventQuery];
	[eventQuery whereKey:@"date" greaterThanOrEqualTo:startDate];
	[eventQuery whereKey:@"date" lessThanOrEqualTo:endDate];

	PFQuery *query = [self basePromotionQuery];
	[query whereKey:@"event" matchesQuery:eventQuery];
	return query;
}

- (PFQuery *)queryForPromotionForEvent:(NSString *)eventId {
	PFQuery *query = [self basePromotionQuery];
	[query whereKey:@"eventId" equalTo:eventId];
	return query;
}

#pragma mark - Guestlist Queries
- (PFQuery *)queryForGuestlistsForPromotion {
    PFQuery *promotionQuery = [self basePromotionQuery];
    [promotionQuery whereKey:@"host" equalTo:[THLUser currentUser]];
    
    PFQuery *query = [self baseGuestlistQuery];
    [query whereKey:@"Promotion" matchesQuery:promotionQuery];
    return query;
}

//TODO: Query for Guestlist Invite for User for Event
- (PFQuery *)queryForGuestlistInviteForUser:(THLUser *)user atEvent:(NSString *)eventId {
    PFQuery *guestlistQuery = [self baseGuestlistQuery];
    [guestlistQuery whereKey:@"eventId" equalTo:eventId];
    
    PFQuery *query = [self baseGuestlistInviteQuery];
    [query whereKey:@"Guest" equalTo:user];
    [query whereKey:@"Guestlist" matchesQuery:guestlistQuery];
    [query whereKey:@"response" notEqualTo:[NSNumber numberWithInteger:2]];
    return query;
}

- (PFQuery *)queryForInvitesOnGuestlist:(THLGuestlist *)guestlist {
    PFQuery *query = [self baseGuestlistInviteQuery];
    [query whereKey:@"Guestlist" equalTo:guestlist];
    return query;
}

- (PFQuery *)queryForGuestlistInviteWithId {
    PFQuery *query = [self baseGuestlistInviteQuery];
    [query includeKey:@"Guestlist.Promotion"];
    [query includeKey:@"Guestlist.Promotion.event"];
    [query includeKey:@"Guestlist.Promotion.event.location"];
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
    [query includeKey:@"event.location"];
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
    [query includeKey:@"Owner"];
    [query includeKey:@"Promotion"];
    [query includeKey:@"Promotion.event"];
    [query includeKey:@"Promotion.event.location"];
    return query;
}

/**
 *  Generic query for THLGuestlistInvite
 *	Includes: guest, guestlist
 */
- (PFQuery *)baseGuestlistInviteQuery {
    PFQuery *query = [THLGuestlistInvite query];
    [query includeKey:@"Guestlist"];
    [query includeKey:@"Guestlist.Owner"];
    [query includeKey:@"Guestlist.Promotion"];
    [query includeKey:@"Guestlist.Promotion.event"];
    [query includeKey:@"Guestlist.Promotion.event.location"];
    [query includeKey:@"Guest"];
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
