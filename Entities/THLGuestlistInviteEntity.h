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
@property (nonatomic) BOOL didOpen;

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, strong) THLGuestEntity *guest;
@property (nonatomic, strong) THLGuestlistEntity *guestlist;
@property (nonatomic, strong) NSURL *qrCode;

- (BOOL)isAccepted;
- (BOOL)isPending;
- (BOOL)isDeclined;
- (BOOL)isCheckedIn;

- (BOOL)isOwnerInvite;

- (BOOL)guestlistIsAccepted;
- (BOOL)guestlistIsDeclined;
- (BOOL)guestlistIsCheckedIn;
@end