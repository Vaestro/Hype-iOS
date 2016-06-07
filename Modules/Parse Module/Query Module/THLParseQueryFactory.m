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
- (PFQuery *)queryForEventsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate
{
    THLUser *currentUser = [THLUser currentUser];
    PFQuery *query = [self baseEventQuery];
    [query whereKey:@"date" greaterThanOrEqualTo:startDate];
    [query whereKey:@"date" lessThanOrEqualTo:endDate];
    /**
     *  If User is a Guest fetch all events. If User is Host, only fetch Events that they have a promotion for.
     */
    if (currentUser.type == THLUserTypeHost) {
        [query whereKey:@"host" equalTo:[THLUser currentUser]];
    }
	return query;
}

#pragma mark - Guestlist Queries
- (PFQuery *)queryForGuestlistWithId
{
    PFQuery *query = [self baseGuestlistQuery];
    return query;
}

- (PFQuery *)queryForGuestlists
{
    PFQuery *eventQuery = [self baseEventQuery];
    [eventQuery whereKey:@"host" equalTo:[THLUser currentUser]];

    PFQuery *query = [self baseGuestlistQuery];
    [query whereKey:@"event" matchesQuery:eventQuery];
//    Fetch all guestlists so local database can be updated
//    [query whereKey:@"date" greaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60*300]];
    return query;
}

- (PFQuery *)queryForGuestlistsForEvent:(NSString *)eventId
{
    PFQuery *eventQuery = [self baseEventQuery];
    [eventQuery whereKey:@"objectId" equalTo:eventId];
    [eventQuery whereKey:@"host" equalTo:[THLUser currentUser]];
    
    PFQuery *query = [self baseGuestlistQuery];
    [query whereKey:@"event" matchesQuery:eventQuery];
    return query;
}

//TODO: Query for Guestlist Invite for User for Event
- (PFQuery *)queryForGuestlistInviteForEvent:(NSString *)eventId {
    
    PFQuery *eventQuery = [self baseEventQuery];
    [eventQuery whereKey:@"objectId" equalTo:eventId];
    
    PFQuery *guestlistQuery = [self baseGuestlistQuery];
    [guestlistQuery whereKey:@"event" matchesQuery:eventQuery];

    PFQuery *query = [self baseGuestlistInviteQuery];
    [query whereKey:@"Guest" equalTo:[THLUser currentUser]];
    [query whereKey:@"Guestlist" matchesQuery:guestlistQuery];
    [query whereKey:@"response" notEqualTo:[NSNumber numberWithInteger:-1]];
    return query;
}

- (PFQuery *)localQueryForAcceptedInviteForEvent:(NSString *)eventId {
    PFQuery *eventQuery = [self baseEventQuery];
    [eventQuery whereKey:@"objectId" equalTo:eventId];
    
    PFQuery *guestlistQuery = [self baseGuestlistQuery];
    [guestlistQuery whereKey:@"event" matchesQuery:eventQuery];
    
    PFQuery *query = [self baseGuestlistInviteQuery];
    [query whereKey:@"Guest" equalTo:[THLUser currentUser]];
    [query whereKey:@"Guestlist" matchesQuery:guestlistQuery];
    [query whereKey:@"response" equalTo:[NSNumber numberWithInteger:1]];
    
    [query fromLocalDatastore];
    
    return query;
}

- (PFQuery *)queryForGuestlistInvitesForUser {
    PFQuery *query = [self baseGuestlistInviteQuery];
    [query whereKey:@"phoneNumber" equalTo:[THLUser currentUser].phoneNumber];
//    TODO: Improve Date + Remove Reponse filtering to fetch all guestlistInvites
//    [query whereKey:@"date" greaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60*300]];
    [query orderByAscending:@"date"];
    [query whereKey:@"response" notEqualTo:[NSNumber numberWithInteger:-1]];
    return query;
}

- (PFQuery *)queryForGuestlistInvitesForUser:(THLUser *)user {
    PFQuery *query = [self baseGuestlistInviteQuery];
    [query whereKey:@"Guest" equalTo:[THLUser currentUser].objectId];
    [query orderByAscending:@"date"];
    //[query whereKey:@"response" notEqualTo:[NSNumber numberWithInteger:-1]];
    return query;
}

- (PFQuery *)queryForInvitesOnGuestlist:(THLGuestlist *)guestlist {
    PFQuery *query = [self baseGuestlistInviteQuery];
    [query whereKey:@"Guestlist" equalTo:guestlist];
    return query;
}

- (PFQuery *)queryForGuestlistInviteWithId {
    PFQuery *query = [self baseGuestlistInviteQuery];
    [query includeKey:@"Guestlist"];
    [query includeKey:@"Guestlist.event"];
    [query includeKey:@"Guestlist.event.location"];
    return query;
}

- (PFQuery *)queryForUserWithId:(NSString *)userID {
    PFQuery *query = [self baseUserQuery];
    [query whereKey:@"objectId" equalTo:userID];
    return query;
}

#pragma mark - PerkItemStore Queries
- (PFQuery *)queryForAllPerkStoreItems {
    PFQuery *query = [self basePerkStoreItem];
    return query;
}

#pragma mark - Class Queries

/**
 *  Generic query for THLUChannel.
 *	Includes: (none)
 */
//- (PFQuery *)baseChannelQuery {
//    //PFQuery *query = [[PFQuery alloc] initWithClassName:@"Channel"];
////    PFQuery *query = [THLChannel query];
//    //[query includeKey:@"event.location"];
//    return query;
//}

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
    [query includeKey:@"host"];
	return query;
}

/**
 *  Generic query for THLGuestlist
 *	Includes: guest, promotion
 */
- (PFQuery *)baseGuestlistQuery {
    PFQuery *query = [THLGuestlist query];
    [query includeKey:@"Owner"];
    [query includeKey:@"event"];
    [query includeKey:@"event.host"];
    [query includeKey:@"event.location"];
    return query;
}

/**
 *  Generic query for THLGuestlistInvite
 *	Includes: guest, guestlist
 */
- (PFQuery *)baseGuestlistInviteQuery {
    PFQuery *query = [THLGuestlistInvite query];
    [query includeKey:@"Guest"];
    [query includeKey:@"sender"];
    [query includeKey:@"Guestlist"];
    [query includeKey:@"Guestlist.Owner"];
    [query includeKey:@"Guestlist.event"];
    [query includeKey:@"Guestlist.event.host"];
    [query includeKey:@"Guestlist.event.location"];
    return query;
}

/**
 *  Generic query for THLPerkStoreItem
 *	Includes: (none)
 */
- (PFQuery *)basePerkStoreItem {
    PFQuery *query = [THLPerkStoreItem query];
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
