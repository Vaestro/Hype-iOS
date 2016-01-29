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
@class THLEventDetailDataManager;
@class THLYapDatabaseManager;
@class THLGuestlistInviteEntity;

@protocol THLLocationServiceInterface;
@protocol THLGuestlistServiceInterface;

@protocol THLEventDetailDataManagerDelegate <NSObject>
- (void)dataManager:(THLEventDetailDataManager *)dataManager didGetNotifiedAboutNewGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite forEvent:(THLEventEntity *)event error:(NSError *)error;
@end

@interface THLEventDetailDataManager : NSObject
@property (nonatomic, weak) id<THLEventDetailDataManagerDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLLocationServiceInterface> locationService;
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) THLYapDatabaseManager *databaseManager;

- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService
                       guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
						  entityMappper:(THLEntityMapper *)entityMapper
                        databaseManager:(THLYapDatabaseManager *)databaseManager;

- (BFTask<CLPlacemark *> *)fetchPlacemarkForAddress:(NSString *)address;
- (BFTask *)fetchGuestlistInviteForEvent:(THLEventEntity *)event;
@end
