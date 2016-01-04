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

@interface THLGuestlistInviteEntity : THLEntity
@property (nonatomic) THLStatus response;
@property (nonatomic) BOOL checkInStatus;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) THLGuestEntity *guest;
@property (nonatomic, strong) THLGuestlistEntity *guestlist;

- (BOOL)isAccepted;
- (BOOL)isPending;
- (BOOL)isDeclined;

- (BOOL)isOwnerInvite;

- (BOOL)guestlistIsAccepted;
- (BOOL)guestlistIsDeclined;
@end