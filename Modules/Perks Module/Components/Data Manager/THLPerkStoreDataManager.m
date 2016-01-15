//
//  THLPerkStoreDataManager.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkStoreDataManager.h"
#import "THLPerkStoreItemServiceInterface.h"
#import "THLEventEntity.h"
#import "THLDataStoreDomain.h"
#import "THLEntityMapper.h"
#import "THLDataStore.h"
#import "THLUser.h"

@implementation THLPerkStoreDataManager
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                entityMapper:(THLEntityMapper *)entityMapper
                perkService:(id<THLPerkStoreItemServiceInterface>)perkService {
    
    if (self = [super init]) {
        _dataStore = dataStore;
        _entityMapper = entityMapper;
        _perkService = perkService;
    }
    return self;
}

- (BFTask *)fetchAllPerkStoreItems {
    WEAKSELF();
    STRONGSELF();
    return [[_perkService fetchAllPerkStoreItems] continueWithSuccessBlock:^id(BFTask *task) {
        THLDataStoreDomain *domain = [SSELF domainForPerks];
        NSSet *entities = [NSSet setWithArray:[SSELF.entityMapper mapPerkStoreItems:task.result]];
        [SSELF.dataStore refreshDomain:domain withEntities:entities andDeleteEntities:YES];
        return [BFTask taskWithResult:nil];
    }];
}

- (THLDataStoreDomain *)domainForPerks {
    THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
        THLPerkStoreItemEntity *perkStoreItemEntity = (THLPerkStoreItemEntity *)entity;
        return perkStoreItemEntity;
    }];
    return domain;
}

- (BFTask *)fetchCreditsForUser {
    THLUser *currentUser = [THLUser currentUser];
    return [[currentUser fetchInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        return [BFTask taskWithResult:nil];
    }];
}

@end
