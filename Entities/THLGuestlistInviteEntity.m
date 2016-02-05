//
//  THLGuestlistInviteEntity.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/27/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInviteEntity.h"
#import "THLGuestlistEntity.h"
#import "THLGuestEntity.h"
#import "THLUser.h"

@implementation THLGuestlistInviteEntity
- (BOOL)isAccepted {
    return self.response == THLStatusAccepted;
}

- (BOOL)isPending {
    return self.response == THLStatusPending;
}

- (BOOL)isDeclined {
    return self.response == THLStatusDeclined;
}

- (BOOL)isCheckedIn {
    return self.checkInStatus;
}

- (BOOL)guestlistIsAccepted {
    return [self.guestlist isAccepted];
}

- (BOOL)guestlistIsDeclined {
    return [self.guestlist isDeclined];
}


- (BOOL)isOwnerInvite {
    return [self.guestlist.owner.objectId isEqualToString:[THLUser currentUser].objectId];
}

-(BOOL)guestlistIsCheckedIn {
    return self.checkInStatus;
}

@end