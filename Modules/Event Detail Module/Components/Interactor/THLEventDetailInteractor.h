//
//  THLEventDetailInteractor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEventDetailDataManager;
@class THLEventDetailInteractor;
@class THLLocationEntity;
@class THLPromotionEntity;
@class THLUser;
@class THLEvent;
@class THLEventEntity;
@class THLGuestlistEntity;

@protocol THLEventDetailInteractorDelegate <NSObject>
- (void)interactor:(THLEventDetailInteractor *)interactor didGetPlacemark:(CLPlacemark *)placemark forLocation:(THLLocationEntity *)locationEntity error:(NSError *)error;
- (void)interactor:(THLEventDetailInteractor *)interactor didGetGuestlist:(THLGuestlistEntity *)guestlist forGuest:(NSString *)guestId forEvent:(NSString *)eventId error:(NSError *)error;
- (void)interactor:(THLEventDetailInteractor *)interactor didGetPromotion:(THLPromotionEntity *)promotionEntity forEvent:(NSString *)eventId error:(NSError *)error;
@end

@interface THLEventDetailInteractor : NSObject
@property (nonatomic, weak) id<THLEventDetailInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLEventDetailDataManager *dataManager;
- (instancetype)initWithDataManager:(THLEventDetailDataManager *)dataManager;

- (void)getPlacemarkForLocation:(THLLocationEntity *)locationEntity;
- (void)getPromotionForEvent:(NSString *)eventId;

- (void)getGuestlistForGuest:(NSString *)guestId forEvent:(NSString *)eventId;
@end
