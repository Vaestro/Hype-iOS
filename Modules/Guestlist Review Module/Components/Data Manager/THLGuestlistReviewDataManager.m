//
//  THLGuestlistReviewDataManager.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistReviewDataManager.h"

#import "THLDataStore.h"
#import "THLGuestlistServiceInterface.h"
#import "THLGuestlist.h"
#import "THLDataStoreDomain.h"
#import "THLEntityMapper.h"
#import "THLGuestlistInvite.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestlistEntity.h"

@interface THLGuestlistReviewDataManager()

@end

@implementation THLGuestlistReviewDataManager
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
                               dataStore:(THLDataStore *)dataStore {
    if (self = [super init]) {
        _dataStore = dataStore;
        _entityMapper = entityMapper;
        _guestlistService = guestlistService;
    }
    return self;
}

- (BFTask *)fetchGuestlistInvitesForGuestlist:(THLGuestlistEntity *)guestlist {
    WEAKSELF();
    STRONGSELF();
    return [[_guestlistService fetchInvitesOnGuestlist:[THLGuestlist objectWithoutDataWithObjectId:guestlist.objectId]] continueWithSuccessBlock:^id(BFTask *task) {
//        THLDataStoreDomain *domain = [SSELF domainForGuestlistInvitesForGuestlist:guestlist];
        NSSet *entities = [NSSet setWithArray:[SSELF.entityMapper mapGuestlistInvites:task.result]];
//        [SSELF.dataStore refreshDomain:domain withEntities:entities];
        [_dataStore updateOrAddEntities:entities];
        return [BFTask taskWithResult:entities];
    }];
}

//- (THLDataStoreDomain *)domainForGuestlistInvitesForGuestlist:(THLGuestlistEntity *)guestlist {
//    THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
//        THLGuestlistInviteEntity *guestlistInviteEntity = (THLGuestlistInviteEntity *)entity;
//        return ([guestlistInviteEntity guestlist].objectId == guestlist.objectId);
//    }];
//    return domain;
//}

- (BFTask *)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withResponse:(THLStatus)response {
    return [_guestlistService updateGuestlistInvite:[THLGuestlistInvite objectWithoutDataWithObjectId:guestlistInvite.objectId] withResponse:response];
}

- (BFTask *)updateGuestlist:(THLGuestlistEntity *)guestlist withReviewStatus:(THLStatus)reviewStatus {
    return [_guestlistService updateGuestlist:[THLGuestlist objectWithoutDataWithObjectId:guestlist.objectId] withReviewStatus:reviewStatus];
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
