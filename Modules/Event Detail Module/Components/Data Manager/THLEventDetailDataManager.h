//
//  THLEventDetailDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;
@class THLEvent;
@class THLUser;
@class THLEntityMapper;
@class THLEventEntity;

@protocol THLLocationServiceInterface;
@protocol THLPromotionServiceInterface;
@protocol THLGuestlistServiceInterface;

@interface THLEventDetailDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLLocationServiceInterface> locationService;
@property (nonatomic, readonly, weak) id<THLPromotionServiceInterface> promotionService;
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService
					   promotionService:(id<THLPromotionServiceInterface>)promotionService
                       guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
						  entityMappper:(THLEntityMapper *)entityMapper;

- (BFTask<CLPlacemark *> *)fetchPlacemarkForAddress:(NSString *)address;
- (BFTask *)fetchPromotionForEvent:(NSString *)eventId;
- (BFTask *)fetchGuestlistInviteForUser:(THLUser *)user atEvent:(THLEventEntity *)event;
@end
