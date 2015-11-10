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

@protocol THLGuestlistServiceInterface <NSObject>

#pragma mark - Guestlist Services
- (BFTask *)fetchGuestlistsForPromotion;
- (BFTask *)createGuestlistForPromotion:(THLPromotionEntity *)promotionEntity withInvites:(NSArray *)guestPhoneNumbers;
- (BFTask *)updateGuestlist:(NSString *)guestlistId withInvites:(NSArray *)guestPhoneNumbers;

#pragma mark - Guestlist Invite Services

- (BFTask *)fetchInvitesOnGuestlist:(THLGuestlist *)guestlist;
- (BFTask *)fetchGuestlistInviteForUser:(THLUser *)user atEvent:(NSString *)eventId;
- (BFTask *)fetchGuestlistInviteWithId:(NSString *)guestlistInviteId;
- (BFTask *)updateGuestlistInvite:(THLGuestlistInvite *)guestlistInvite withResponse:(THLStatus)response;


@end
