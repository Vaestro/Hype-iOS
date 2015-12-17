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
    STRONGSELF();
    return [[_guestlistService fetchGuestlistInviteWithId:guestlistInviteId] continueWithSuccessBlock:^id(BFTask *task) {
        THLGuestlistInvite *fetchedGuestlistInvite = task.result;
        THLGuestlistInviteEntity *guestlistInviteEntity = [SSELF.entityMapper mapGuestlistInvite:fetchedGuestlistInvite];
//        HACK to get guestlist Invite to update with updated Guestlist
        guestlistInviteEntity.updatedAt = [NSDate date];
        [SSELF.dataStore updateOrAddEntities:[NSSet setWithArray:@[guestlistInviteEntity]]];
        return guestlistInviteEntity;
    }];
}

- (BFTask *)fetchGuestlistWithId:(NSString *)guestlistId {
    WEAKSELF();
    STRONGSELF();
    return [[_guestlistService fetchGuestlistWithId:guestlistId] continueWithSuccessBlock:^id(BFTask *task) {
        THLGuestlist *fetchedGuestlist = task.result;
        THLGuestlistEntity *guestlistEntity = [SSELF.entityMapper mapGuestlist:fetchedGuestlist];
        [SSELF.dataStore updateOrAddEntities:[NSSet setWithArray:@[guestlistEntity]]];
        return guestlistEntity;
    }];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}

@end
