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

@implementation THLPopupNotificationDataManager
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
    }
    return self;
}

#pragma mark - Interface
- (BFTask *)fetchGuestlistInviteWithId:(NSString *)guestlistInviteId {
    return [[_guestlistService fetchGuestlistInviteWithId:guestlistInviteId] continueWithSuccessBlock:^id(BFTask *task) {
            THLGuestlistInvite *fetchedGuestlistInvite = task.result;
            THLGuestlistInviteEntity *mappedGuestlistInvite = [_entityMapper mapGuestlistInvite:fetchedGuestlistInvite];
            return mappedGuestlistInvite;
    }];
}



@end
