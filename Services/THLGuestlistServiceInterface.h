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
@class THLPromotion;
@class THLUser;
@class THLEvent;
@class THLGuestlistInvite;

@protocol THLGuestlistServiceInterface <NSObject>
- (BFTask *)fetchInvitesOnGuestlist:(THLGuestlist *)guestlist;
- (BFTask *)fetchGuestlistForGuest:(THLUser *)guest forEvent:(NSString *)eventId;
//- (BFTask *)createGuestlistForPromotion:(THLPromotion *)promotion forOwner:(THLUser *)owner;
@end
