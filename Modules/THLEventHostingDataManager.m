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
        [WSELF.dataStore refreshDomain:domain withEntities:entities forCollectionKey:eventId];
        return [BFTask taskWithResult:entities];
    }];
}

- (THLDataStoreDomain *)domainForGuestlistsForPromotion {
    THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
        THLGuestlistInviteEntity *guestlistEntity = (THLGuestlistInviteEntity *)entity;
//        TODO: Basic Hack to make function work
        return (guestlistEntity != nil);
    }];
    return domain;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
