//
//  THLGuestlistInvite.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@class THLGuestlist;
@class THLUser;

typedef NS_ENUM(NSInteger, THLGuestlistInviteResponse) {
	THLGuestlistInviteResponsePending = 0,
	THLGuestlistInviteResponseAccepted,
	THLGuestlistInviteResponseRejected,
	THLGuestlistInviteResponse_Count
};

@interface THLGuestlistInvite : PFObject<PFSubclassing>
@property (nonatomic, retain) THLUser *sender;
@property (nonatomic, retain) THLUser *recipient;
@property (nonatomic, retain) THLGuestlist *guestlist;
@property (nonatomic) THLGuestlistInviteResponse response;
@end
