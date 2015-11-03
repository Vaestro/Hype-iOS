//
//  THLGuestlistInviteEntity.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/27/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
@class THLGuestEntity;
@class THLGuestlistEntity;

typedef NS_ENUM(NSInteger, THLGuestlistInviteEntityResponse) {
    THLGuestlistInviteEntityResponsePending = 0,
    THLGuestlistInviteEntityResponseAccepted,
    THLGuestlistInviteEntityResponseRejected,
    THLGuestlistInviteEntityResponse_Count
};

@interface THLGuestlistInviteEntity : THLEntity
@property(nonatomic) THLGuestlistInviteEntityResponse *response;
@property(nonatomic) NSNumber *checkInStatus;
@property(nonatomic, strong) NSString *eventId;
@property(nonatomic, strong) THLGuestEntity *guest;
@property(nonatomic, strong) THLGuestlistEntity *guestlist;

@end