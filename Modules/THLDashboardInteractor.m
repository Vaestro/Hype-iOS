//
//  THLDashboardInteractor.m
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardInteractor.h"
#import "THLDashboardDataManager.h"

@interface THLDashboardInteractor()

@end

@implementation THLDashboardInteractor
- (instancetype)initWithDataManager:(THLDashboardDataManager *)dataManager {
    if (self = [super init]) {
        _dataManager = dataManager;
    }
    return self;
}

- (void)checkForGuestlistInvites {
    WEAKSELF();
    [[_dataManager fetchGuestlistInvitesForUser] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [WSELF.delegate interactor:WSELF didGetAcceptedGuestlistInvite:task.result error:task.error];
        return nil;
    }];
}
@end
