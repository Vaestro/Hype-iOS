//
//  THLGuestProfileViewController+THLGuestlistEntity.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/22/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
@class THLGuestEntity;
@class THLEventEntity;

@interface THLGuestlistEntity : THLEntity
@property(nonatomic) THLStatus reviewStatus;
@property(nonatomic, strong) THLGuestEntity *owner;
@property(nonatomic, strong) THLEventEntity *event;
@property (nonatomic, copy) NSDate *date;

@property(nonatomic, strong) NSArray<THLGuestEntity *> *allGuests;
@property(nonatomic, strong) NSArray<THLGuestEntity *> *invitedGuests;
@property(nonatomic, strong) NSArray<THLGuestEntity *> *acceptedGuests;
@property(nonatomic, strong) NSArray<THLGuestEntity *> *confirmedGuests;
@property(nonatomic, strong) NSArray<THLGuestEntity *> *declinedGuests;

- (BOOL)isAccepted;
- (BOOL)isPending;
- (BOOL)isDeclined;

@end
