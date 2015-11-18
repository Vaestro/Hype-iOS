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

@interface THLDashboardDataManager()

@end

@implementation THLDashboardDataManager
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                          entityMappper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
    }
    return self;
}

- (BFTask *)fetchGuestlistInvitesForUser {
    WEAKSELF();
    return [[_guestlistService fetchGuestlistInvitesForUser] continueWithSuccessBlock:^id(BFTask *task) {
        THLGuestlistInvite *fetchedGuestlistInvite = task.result;
        THLGuestlistInviteEntity *mappedGuestlistInvite = [WSELF.entityMapper mapGuestlistInvite:fetchedGuestlistInvite];
        return mappedGuestlistInvite;
    }];
}

@end
