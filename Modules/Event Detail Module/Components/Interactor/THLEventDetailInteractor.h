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
@class THLGuestlistEntity;

@protocol THLEventDetailInteractorDelegate <NSObject>
- (void)interactor:(THLEventDetailInteractor *)interactor didGetPlacemark:(CLPlacemark *)placemark forLocation:(THLLocationEntity *)locationEntity error:(NSError *)error;
- (void)interactor:(THLEventDetailInteractor *)interactor didGetGuestlist:(THLGuestlistEntity *)guestlist forGuest:(THLUser *)guest forEvent:(NSString *)eventId error:(NSError *)error;

@end

@interface THLEventDetailInteractor : NSObject
@property (nonatomic, weak) id<THLEventDetailInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLEventDetailDataManager *dataManager;
- (instancetype)initWithDataManager:(THLEventDetailDataManager *)dataManager;

- (void)getPlacemarkForLocation:(THLLocationEntity *)locationEntity;
- (void)getGuestlistForGuest:(THLUser *)guest forEvent:(NSString *)eventId;
@end
