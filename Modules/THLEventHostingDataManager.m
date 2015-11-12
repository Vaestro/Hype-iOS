//
//  THLEventHostingDataManager.m
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventHostingDataManager.h"

#import "THLDataStore.h"
#import "THLGuestlistServiceInterface.h"
#import "THLGuestlistEntity.h"
#import "THLDataStoreDomain.h"
#import "THLEntityMapper.h"

@interface THLEventHostingDataManager()

@end

@implementation THLEventHostingDataManager
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                     entityMapper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _dataStore = dataStore;
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
    }
    return self;
}



- (BFTask *)fetchGuestlistsForPromotionAtEvent:(NSString *)eventId {
    WEAKSELF();
    return [[_guestlistService fetchGuestlistsForPromotionAtEvent:eventId] continueWithSuccessBlock:^id(BFTask *task) {
        THLDataStoreDomain *domain = [WSELF domainForGuestlistsForPromotion];
        NSSet *entities = [NSSet setWithArray:[WSELF.entityMapper mapGuestlists:task.result]];
#warning Hackaround to fix data store from causing problems when accessing guestlist invites from different guestlists
        [WSELF.dataStore purge];
        
        [WSELF.dataStore refreshDomain:domain withEntities:entities];
        return [BFTask taskWithResult:entities];
    }];
}

- (THLDataStoreDomain *)domainForGuestlistsForPromotion {
    THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
        THLGuestlistInviteEntity *guestlistEntity = (THLGuestlistInviteEntity *)entity;
        return guestlistEntity;
    }];
    return domain;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
