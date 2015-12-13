//
//  THLDashboardInteractor.m
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardInteractor.h"
#import "THLDashboardDataManager.h"
#import "THLViewDataSourceFactory.h"
#import "THLGuestlistInviteEntity.h"
#import "THLUser.h"
#import "THLGuestEntity.h"

@interface THLDashboardInteractor()

@end

@implementation THLDashboardInteractor
- (instancetype)initWithDataManager:(THLDashboardDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    if (self = [super init]) {
        _dataManager = dataManager;
        _viewDataSourceFactory = viewDataSourceFactory;
    }
    return self;
}

- (void)updateGuestlistInvites {
    WEAKSELF();
    STRONGSELF();
    [[_dataManager fetchGuestlistInvitesForUser] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [SSELF.delegate interactor:SSELF didUpdateGuestlistInvites:task.error];
        return nil;
    }];
}

- (THLViewDataSource *)getDataSource {
    [self updateGuestlistInvites];
    THLViewDataSourceGrouping *grouping = [self viewGrouping];
    THLViewDataSourceSorting *sorting = [self viewSorting];
    NSArray *groups = @[ @"Pending Invites", @"Upcoming Events"];
    THLViewDataSource *dataSource = [_viewDataSourceFactory createDataSourceWithFixedGrouping:grouping sorting:sorting groups:groups key:@"kTHLDashboardModuleViewKey"];
    return dataSource;
}

- (THLViewDataSourceGrouping *)viewGrouping {
    return [THLViewDataSourceGrouping withEntityBlock:^NSString *(NSString *collection, THLEntity *entity) {
        if ([entity isKindOfClass:[THLGuestlistInviteEntity class]]) {
            THLGuestlistInviteEntity *guestlistInviteEntity = (THLGuestlistInviteEntity *)entity;
            if ([guestlistInviteEntity.guest.objectId isEqualToString:[THLUser currentUser].objectId]) {
                if (guestlistInviteEntity.response == THLStatusPending) {
                    return @"Pending Invites";
                } else if (guestlistInviteEntity.response == THLStatusAccepted) {
                    return @"Upcoming Events";
                }
            }
        }
        return nil;
    }];
}

- (THLViewDataSourceSorting *)viewSorting {
    return [THLViewDataSourceSorting withSortingBlock:^NSComparisonResult(THLEntity *entity1, THLEntity *entity2) {
        THLGuestlistInviteEntity *guestlistInvite1 = (THLGuestlistInviteEntity *)entity1;
        THLGuestlistInviteEntity *guestlistInvite2 = (THLGuestlistInviteEntity *)entity2;
        return [[NSNumber numberWithInteger:guestlistInvite1.response] compare:[NSNumber numberWithInteger:guestlistInvite2.response]];
    }];
}
@end
