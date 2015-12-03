//
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPopupNotificationDataManager.h"
#import "THLGuestlistServiceInterface.h"
#import "THLGuestlistEntity.h"
#import "THLGuestlistInviteEntity.h"
#import "THLEntityMapper.h"
#import "THLDataStore.h"

@implementation THLPopupNotificationDataManager
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
                               dataStore:(THLDataStore *)dataStore {
    if (self = [super init]) {
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
        _dataStore = dataStore;
    }
    return self;
}

#pragma mark - Interface
- (BFTask *)fetchGuestlistInviteWithId:(NSString *)guestlistInviteId {
    WEAKSELF();
    return [[_guestlistService fetchGuestlistInviteWithId:guestlistInviteId] continueWithSuccessBlock:^id(BFTask *task) {
        THLGuestlistInviteEntity *guestlistInviteEntity = [WSELF.entityMapper mapGuestlistInvite:task.result];
        [WSELF.dataStore updateOrAddEntities:[NSSet setWithArray:@[guestlistInviteEntity]]];
        return guestlistInviteEntity;
    }];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}

@end
