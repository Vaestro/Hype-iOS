//
//  THLGuestlistServiceInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;
@class THLGuestlist;

@class THLUser;
@class THLEvent;
@class THLGuestlistInvite;
@class THLEventEntity;
@class THLBeaconEntity;
@class THLBeacon;

@protocol THLGuestlistServiceInterface <NSObject>

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists For Host at a Event/Promotion
//----------------------------------------------------------------
- (BFTask *)fetchGuestlistsForEvent:(NSString *)eventId;

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists For Host at Dashboard Notifications
//----------------------------------------------------------------
- (BFTask *)fetchGuestlistsRequestsForHost;

//----------------------------------------------------------------
#pragma mark - Fetch Guestlist For Guest Using The Guestlist ID
//----------------------------------------------------------------
- (BFTask *)fetchGuestlistWithId:(NSString *)guestlistId;

//----------------------------------------------------------------
#pragma mark - Create Additional Guestlist Invites for an Existing Guestlist
//----------------------------------------------------------------
- (BFTask *)updateGuestlist:(NSString *)guestlistId withInvites:(NSArray *)guestPhoneNumbers forEvent:(THLEventEntity *)eventEntity;

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists Invites For Guestlist
//----------------------------------------------------------------

- (BFTask *)fetchInvitesOnGuestlist:(THLGuestlist *)guestlist;

//----------------------------------------------------------------
#pragma mark - Fetch Guestlist For Guest For a Event/Promotion
//----------------------------------------------------------------
- (BFTask *)fetchGuestlistInviteForEvent:(THLEventEntity *)event;

- (BFTask *)fetchGuestlistInvitesForUser;

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists For Guest Using The Guestlist Invite ID
//----------------------------------------------------------------
- (BFTask *)fetchGuestlistInviteWithId:(NSString *)guestlistInviteId;


//----------------------------------------------------------------
#pragma mark - Create Guestlist For Event
//----------------------------------------------------------------
- (BFTask *)createGuestlistForEvent:(THLEventEntity *)event withInvites:(NSArray *)guestPhoneNumbers;


//----------------------------------------------------------------
#pragma mark - Update Guest's Guestlist Invite Response Status
//----------------------------------------------------------------
- (BFTask *)updateGuestlistInvite:(THLGuestlistInvite *)guestlistInvite withResponse:(THLStatus)response;

//----------------------------------------------------------------
#pragma mark - Update Guest's Guestlist Invite didOpen Status
//----------------------------------------------------------------
- (BFTask *)updateGuestlistInviteToOpened:(THLGuestlistInvite *)guestlistInvite;

//----------------------------------------------------------------
#pragma mark - Update a Guestlist's Review Status
//----------------------------------------------------------------
- (BFTask *)updateGuestlist:(THLGuestlist *)guestlist withReviewStatus:(THLStatus)reviewStatus;


//----------------------------------------------------------------
#pragma mark - Update a Guestlist Invite's Check In Status
//----------------------------------------------------------------
- (BFTask *)updateGuestlistInvite:(THLGuestlistInvite *)guestlistInvite withCheckInStatus:(BOOL)status;


@end
