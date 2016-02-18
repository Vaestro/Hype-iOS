//
//  THLDashboardDataManager.m
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardDataManager.h"
#import "THLGuestlistServiceInterface.h"
#import "THLEntityMapper.h"
#import "THLYapDatabaseManager.h"
#import "THLDataStore.h"
#import "THLDataStoreDomain.h"
#import "THLGuestlistInviteEntity.h"

@implementation THLDashboardDataManager
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

- (BFTask *)fetchGuestlistInvitesForUser {
    WEAKSELF();
    STRONGSELF();
    return [[_guestlistService fetchGuestlistInvitesForUser] continueWithSuccessBlock:^id(BFTask *task) {
//        THLDataStoreDomain *domain = [SSELF domainForPendingOrAcceptedGuestlistInvites];
        NSSet *entities = [NSSet setWithArray:[SSELF.entityMapper mapGuestlistInvites:task.result]];
        //        HACK to get guestlist Invite to update with updated Guestlist
        for (THLGuestlistInviteEntity *guestlistInviteEntity in entities) {
            guestlistInviteEntity.updatedAt = [NSDate date];
        }
//        [SSELF.dataStore refreshDomain:domain withEntities:entities andDeleteEntities:NO];
        [SSELF.dataStore updateOrAddEntities:entities];
        return [BFTask taskWithResult:entities];
    }];
}

- (THLDataStoreDomain *)domainForPendingOrAcceptedGuestlistInvites {
    THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
        THLGuestlistInviteEntity *guestlistInviteEntity = (THLGuestlistInviteEntity *)entity;
        return ([guestlistInviteEntity.date isLaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60*300]]);
    }];
    return domain;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
