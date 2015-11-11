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
- (PFQuery *)queryForPromotionsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate;
- (PFQuery *)queryForPromotionForEvent:(NSString *)eventId;

#pragma mark - Guestlist Queries
- (PFQuery *)queryForGuestlistsForPromotionAtEvent:(NSString *)eventId;

#pragma mark - Guestlist Invites Queries
- (PFQuery *)queryForGuestlistInviteForUser:(THLUser *)user atEvent:(NSString *)eventId;
- (PFQuery *)queryForInvitesOnGuestlist:(THLGuestlist *)guestlist;
- (PFQuery *)queryForGuestlistInviteWithId;
@end
