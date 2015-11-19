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
@class THLUser;
@class THLEvent;
@class THLEventEntity;
@class THLPromotionEntity;
@class THLGuestlistInviteEntity;

@protocol THLEventDetailInteractorDelegate <NSObject>
- (void)interactor:(THLEventDetailInteractor *)interactor didGetPlacemark:(CLPlacemark *)placemark forLocation:(THLLocationEntity *)locationEntity error:(NSError *)error;
//- (void)interactor:(THLEventDetailInteractor *)interactor userUnavailableForEvent:(THLEventEntity *)event;

- (void)interactor:(THLEventDetailInteractor *)interactor didGetGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite forEvent:(THLEventEntity *)event error:(NSError *)error;
- (void)interactor:(THLEventDetailInteractor *)interactor didGetPromotion:(THLPromotionEntity *)promotionEntity forEvent:(NSString *)eventId error:(NSError *)error;
@end

@interface THLEventDetailInteractor : NSObject
@property (nonatomic, weak) id<THLEventDetailInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLEventDetailDataManager *dataManager;
- (instancetype)initWithDataManager:(THLEventDetailDataManager *)dataManager;

- (void)getPlacemarkForLocation:(THLLocationEntity *)locationEntity;
- (void)getPromotionForEvent:(NSString *)eventId;
- (void)checkValidGuestlistInviteForUser:(THLUser *)user atEvent:(THLEventEntity *)event;
@end
