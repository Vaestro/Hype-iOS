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
//        THLDataStoreDomain *domain = [SSELF domainForPendingOrAcceptedGuestlistInvites];
        NSSet *entities = [NSSet setWithArray:[SSELF.entityMapper mapGuestlistInvites:task.result]];
        [SSELF.dataStore updateOrAddEntities:entities];
//        [SSELF.dataStore refreshDomain:domain withEntities:entities];
        return [BFTask taskWithResult:entities];
    }];
}

- (THLDataStoreDomain *)domainForPendingOrAcceptedGuestlistInvites {
    THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
        THLGuestlistInviteEntity *guestlistInviteEntity = (THLGuestlistInviteEntity *)entity;
        return ([guestlistInviteEntity.date isLaterThanOrEqualTo:[[NSDate date] dateByAddingTimeInterval:-60*300]] &&
                (guestlistInviteEntity.response == THLStatusPending || guestlistInviteEntity.response == THLStatusAccepted));
    }];
    return domain;
}

- (BFTask *)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withResponse:(THLStatus)response {
    return [_guestlistService updateGuestlistInvite:[THLGuestlistInvite objectWithoutDataWithObjectId:guestlistInvite.objectId] withResponse:response];
}

- (BFTask *)updateGuestlist:(THLGuestlistEntity *)guestlist withReviewStatus:(THLStatus)reviewStatus {
    return [_guestlistService updateGuestlist:[THLGuestlist objectWithoutDataWithObjectId:guestlist.objectId] withReviewStatus:reviewStatus];
}

- (BFTask *)fetchTokenForCall {
    return [_guestlistService fetchTokenForCall];
}


- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
