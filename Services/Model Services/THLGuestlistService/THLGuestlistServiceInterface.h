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

@class THLPromotionEntity;
@class THLUser;
@class THLEvent;
@class THLGuestlistInvite;
@class THLEventEntity;

@protocol THLGuestlistServiceInterface <NSObject>

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists For Host at a Event/Promotion
//----------------------------------------------------------------
- (BFTask *)fetchGuestlistsForPromotionAtEvent:(NSString *)eventId;

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists For Host at Dashboard Notifications
//----------------------------------------------------------------
- (BFTask *)fetchGuestlistsRequestsForHost;

//----------------------------------------------------------------
#pragma mark - Fetch Guestlist For Guest Using The Guestlist ID
//----------------------------------------------------------------
- (BFTask *)fetchGuestlistWithId:(NSString *)guestlistId;

//----------------------------------------------------------------
#pragma mark - Create Guestlist For Promotion
//----------------------------------------------------------------
- (BFTask *)createGuestlistForPromotion:(THLPromotionEntity *)promotionEntity withInvites:(NSArray *)guestPhoneNumbers;

//----------------------------------------------------------------
#pragma mark - Create Additional Guestlist Invites for an Existing Guestlist
//----------------------------------------------------------------
- (BFTask *)updateGuestlist:(NSString *)guestlistId withInvites:(NSArray *)guestPhoneNumbers forPromotion:(THLPromotionEntity *)promotionEntity;

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
#pragma mark - Update Guest's Guestlist Invite Response Status
//----------------------------------------------------------------
- (BFTask *)updateGuestlistInvite:(THLGuestlistInvite *)guestlistInvite withResponse:(THLStatus)response;

//----------------------------------------------------------------
#pragma mark - Update a Guestlist's Review Status
//----------------------------------------------------------------
- (BFTask *)updateGuestlist:(THLGuestlist *)guestlist withReviewStatus:(THLStatus)reviewStatus;


@end
