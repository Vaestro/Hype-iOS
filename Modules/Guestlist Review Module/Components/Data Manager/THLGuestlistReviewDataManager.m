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

- (BFTask *)fetchGuestlistInvitesForGuestlist:(NSString *)guestlistId {
    return [[_guestlistService fetchInvitesOnGuestlist:[THLGuestlist objectWithoutDataWithObjectId:guestlistId]] continueWithSuccessBlock:^id(BFTask *task) {
        THLDataStoreDomain *domain = [self domainForGuestlistInvites];
        NSSet *entities = [NSSet setWithArray:[_entityMapper mapGuestlistInvites:task.result]];
        [_dataStore refreshDomain:domain withEntities:entities];
        return [BFTask taskWithResult:entities];
    }];
}

- (THLDataStoreDomain *)domainForGuestlistInvites {
    THLDataStoreDomain *domain = [[THLDataStoreDomain alloc] initWithMemberTestBlock:^BOOL(THLEntity *entity) {
        THLGuestlistInviteEntity *guestlistInviteEntity = (THLGuestlistInviteEntity *)entity;
        return guestlistInviteEntity;
    }];
    return domain;
}

- (BFTask *)updateGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite withResponse:(THLStatus)response {
    return [_guestlistService updateGuestlistInvite:[THLGuestlistInvite objectWithoutDataWithObjectId:guestlistInvite.objectId] withResponse:response];
}

@end
