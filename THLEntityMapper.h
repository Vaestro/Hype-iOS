//
//  THLEntityMapper.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLUser;
@class THLEvent;
@class THLLocation;
@class THLPromotion;
@class THLGuestlist;
@class THLGuestlistInvite;

@class THLUserEntity;
@class THLHostEntity;
@class THLEventEntity;
@class THLLocationEntity;
@class THLPromotionEntity;
@class THLGuestlistEntity;
@class THLGuestlistInviteEntity;

@interface THLEntityMapper : NSObject
- (THLEventEntity *)mapEvent:(THLEvent *)event;
- (THLLocationEntity *)mapLocation:(THLLocation *)location;
- (THLUserEntity *)mapUser:(THLUser *)user;
//- (THLUser *)unmapUser:(THLUserEntity *)userEntity;
- (THLPromotionEntity *)mapPromotion:(THLPromotion *)promotion;
- (THLGuestlistEntity *)mapGuestlist:(THLGuestlist *)guestlist;
- (THLGuestlistInviteEntity *)mapGuestlistInvite:(THLGuestlistInvite *)guestlistInvite;

- (NSArray<THLEventEntity*> *)mapEvents:(NSArray *)events;
- (NSArray<THLLocationEntity*> *)mapLocations:(NSArray *)locations;
- (NSArray *)mapUsers:(NSArray *)users;
- (NSArray *)mapPromotions:(NSArray *)promotions;
- (NSArray *)mapGuestlists:(NSArray *)guestlists;
- (NSArray *)mapGuestlistInvites:(NSArray *)guestlistInvites;

@end
