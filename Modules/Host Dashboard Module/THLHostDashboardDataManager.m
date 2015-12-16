//
//  THLHostDashboardDataManager.m
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLHostDashboardDataManager.h"
#import "THLGuestlistServiceInterface.h"
#import "THLEntityMapper.h"
#import "THLYapDatabaseManager.h"
#import "THLDataStore.h"
#import "THLDataStoreDomain.h"
#import "THLGuestlistEntity.h"
#import "THLPromotionEntity.h"
#import "THLEventEntity.h"

@interface THLHostDashboardDataManager()
@property (nonatomic, strong) YapDatabaseConnection *rwConnection;
@property (nonatomic, strong) YapDatabaseConnection *roConnection;

@end

@implementation THLHostDashboardDataManager
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                           entityMappper:(THLEntityMapper *)entityMapper
                               dataStore:(THLDataStore *)dataStore {
    if (self = [super init]) {
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
        _dataStore = dataStore;
    }
    return self;
}

- (BFTask *)fetchGuestlistsForUser {
    WEAKSELF();
    STRONGSELF();
    return [[_guestlistService fetchGuestlistsRequestsForHost] continueWithSuccessBlock:^id(BFTask *task) {
        THLDataStoreDomain *domain = [SSELF domainForPendingOrAcceptedGuestlists];
        NSSet *entities = [NSSet setWithArray:[SSELF.entityMapper mapGuestlists:task.result]];
        [SSELF.dataStore refreshDomain:domain withEntities:entities andDeleteEntities:NO];
        return [BFTask taskWithResult:entities];
    }];
}

- (THLDataStoreDomain *)domainForPendingOrAcceptedGuestlists {
    THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
        THLGuestlistEntity *guestlistEntity = (THLGuestlistEntity *)entity;
        return ([guestlistEntity.date isLaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60*300]]);
    }];
    return domain;
}

@end