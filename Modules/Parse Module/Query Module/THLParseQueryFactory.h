//
//  THLParseQueryFactory.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFQuery.h"

@class THLEvent;
@class THLUser;
@class THLGuestlist;

/**
 *  Interface for constructing all queries for Parse servers.
 */
@interface THLParseQueryFactory : NSObject
#pragma mark - Event Queries
/**
 *  Query for events with at least one promotion.
 */
- (PFQuery *)queryForEventsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate;

#pragma mark - Promotion Queries
//- (PFQuery *)queryForPromotionsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate;
- (PFQuery *)queryForPromotionForEvent:(NSString *)eventId;

#pragma mark - Guestlist Queries
- (PFQuery *)queryForGuestlistWithId;
- (PFQuery *)queryForGuestlists;
- (PFQuery *)queryForGuestlistsForEvent:(NSString *)eventId;

#pragma mark - Guestlist Invites Queries
- (PFQuery *)queryForGuestlistInviteForEvent:(NSString *)eventId;
- (PFQuery *)queryForGuestlistInvitesForUser;
- (PFQuery *)queryForInvitesOnGuestlist:(THLGuestlist *)guestlist;
- (PFQuery *)queryForGuestlistInviteWithId;

#pragma mark - PerkStoreItem Queries
- (PFQuery *)queryForAllPerkStoreItems;

@end
