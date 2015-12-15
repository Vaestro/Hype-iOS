//
//  THLPerkDataManager.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkDataManager.h"
#import "THLPerkItemStoreServiceInterface.h"
#import "THLEventEntity.h"
#import "THLDataStoreDomain.h"
#import "THLEntityMapper.h"
#import "THLDataStore.h"
#import "THLUser.h"

@implementation THLPerkDataManager
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                entityMapper:(THLEntityMapper *)entityMapper
                perkService:(id<THLPerkItemStoreServiceInterface>)perkService {
    
    if (self = [super init]) {
        _dataStore = dataStore;
        _entityMapper = entityMapper;
        _perkService = perkService;
    }
    return self;
}

- (BFTask *)fetchAllPerkStoreItems {
    WEAKSELF();
    return [[_perkService fetchAllPerkStoreItems] continueWithSuccessBlock:^id(BFTask *task) {
        NSSet *entities = [NSSet setWithArray:[WSELF.entityMapper mapPerkStoreItems:task.result]];
        [WSELF.dataStore updateOrAddEntities:entities];
        return [BFTask taskWithResult:nil];
    }];
}

- (BFTask *)fetchCreditsForUser {
    THLUser *currentUser = [THLUser currentUser];
    return [[currentUser fetchInBackground] continueWithSuccessBlock:^id(BFTask *task) {
        return [BFTask taskWithResult:nil];
    }];
}

@end
