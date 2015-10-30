//
//  THLGuestProfileViewController+THLGuestlistEntity.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/22/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
@class THLGuestEntity;
@class THLPromotionEntity;

typedef NS_ENUM(NSInteger, THLGuestlistEntityReviewStatus) {
    THLGuestlistEntityReviewStatusPending = 0,
    THLGuestlistEntityReviewStatusAccepted,
    THLGuestlistEntityReviewStatusRejected,
    THLGuestlistEntityReviewStatus_Count
};

@interface THLGuestlistEntity : THLEntity
@property(nonatomic) THLGuestlistEntityReviewStatus reviewStatus;
@property(nonatomic, strong) NSString *eventId;
@property(nonatomic, strong) THLGuestEntity *owner;
@property(nonatomic, strong) THLPromotionEntity *promotion;
@property(nonatomic, strong) NSArray<THLGuestEntity *> *allGuests;
@property(nonatomic, strong) NSArray<THLGuestEntity *> *invitedGuests;
@property(nonatomic, strong) NSArray<THLGuestEntity *> *acceptedGuests;
@property(nonatomic, strong) NSArray<THLGuestEntity *> *confirmedGuests;
@property(nonatomic, strong) NSArray<THLGuestEntity *> *declinedGuests;
@end
