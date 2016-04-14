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
@class THLGuestlist;
@class THLGuestlistInvite;
@class THLPerkStoreItem;
@class THLPurchasedPerkItem;
@class THLBeaconEntity;

@class THLUserEntity;
@class THLGuestEntity;
@class THLHostEntity;
@class THLEventEntity;
@class THLLocationEntity;
@class THLGuestlistEntity;
@class THLGuestlistInviteEntity;
@class THLPerkStoreItemEntity;
@class THLPurchasedPerkItemEntity;
@class THLBeacon;

@interface THLEntityMapper : NSObject
- (THLEventEntity *)mapEvent:(THLEvent *)event;
- (THLLocationEntity *)mapLocation:(THLLocation *)location;
//- (THLUserEntity *)mapUser:(THLUser *)user;
- (THLGuestEntity *)mapGuest:(THLUser *)user;
- (THLHostEntity *)mapHost:(THLUser *)user;
- (THLGuestlistEntity *)mapGuestlist:(THLGuestlist *)guestlist;
- (THLGuestlistInviteEntity *)mapGuestlistInvite:(THLGuestlistInvite *)guestlistInvite;
- (THLPerkStoreItemEntity *)mapPerkStoreItem:(THLPerkStoreItem *)perkStoreItem;
- (THLPurchasedPerkItemEntity *)mapPurchasedPerkItem:(THLPurchasedPerkItem *)purchasedPerkItem;
- (THLBeacon *)mapBeaconEntity:(THLBeaconEntity *)beaconEntity;

//- (NSArray *)mapUsers:(NSArray *)users;
- (NSArray<THLEventEntity*> *)mapEvents:(NSArray *)events;
- (NSArray<THLLocationEntity*> *)mapLocations:(NSArray *)locations;
- (NSArray<THLGuestlistEntity*> *)mapGuestlists:(NSArray *)guestlists;
- (NSArray<THLGuestlistInviteEntity*> *)mapGuestlistInvites:(NSArray *)guestlistInvites;
- (NSArray<THLPerkStoreItemEntity*> *)mapPerkStoreItems:(NSArray *)perkStoreItems;
- (NSArray<THLPurchasedPerkItemEntity*> *)mapPurchasedPerkItems:(NSArray *)purchasedPerkItems;

@end
