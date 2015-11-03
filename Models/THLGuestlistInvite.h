//
//  THLGuestlistInvite.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "THLGuestlist.h"
#import "THLUser.h"

typedef NS_ENUM(NSInteger, THLGuestlistInviteReviewStatus) {
	THLGuestlistInviteReviewStatusPending = 0,
	THLGuestlistInviteReviewStatusAccepted,
	THLGuestlistInviteReviewStatusRejected,
	THLGuestlistInviteReviewStatus_Count
};

@interface THLGuestlistInvite : PFObject<PFSubclassing>
@property (nonatomic, retain) THLUser *guest;
@property (nonatomic, retain) THLGuestlist *guestlist;
//TODO: Rename reviewStatus to Response
@property (nonatomic) THLGuestlistInviteReviewStatus reviewStatus;
//TODO: Change CheckInStatus to BOOLEAN
@property (nonatomic, retain) NSNumber *checkInStatus;

@end
