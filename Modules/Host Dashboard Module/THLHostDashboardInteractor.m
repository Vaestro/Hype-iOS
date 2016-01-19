//
//  THLHostDashboardInteractor.m
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLHostDashboardInteractor.h"
#import "THLHostDashboardDataManager.h"
#import "THLViewDataSourceFactory.h"
#import "THLGuestlistEntity.h"
#import "THLUser.h"
#import "THLPromotionEntity.h"
#import "THLHostEntity.h"

@interface THLHostDashboardInteractor()

@end

@implementation THLHostDashboardInteractor
- (instancetype)initWithDataManager:(THLHostDashboardDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    if (self = [super init]) {
        _dataManager = dataManager;
        _viewDataSourceFactory = viewDataSourceFactory;
    }
    return self;
}

- (void)updateGuestlists {
    WEAKSELF();
    STRONGSELF();
    [[_dataManager fetchGuestlistsForUser] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [SSELF.delegate interactor:SSELF didUpdateGuestlists:task.error];
        return nil;
    }];
}

- (THLViewDataSource *)getDataSource {
    [self updateGuestlists];
    THLViewDataSourceGrouping *grouping = [self viewGrouping];
    THLViewDataSourceSorting *sorting = [self viewSorting];
    THLViewDataSource *dataSource = [_viewDataSourceFactory createDataSourceWithGrouping:grouping sorting:sorting key:@"kTHLHostDashboardModuleViewKey"];
    return dataSource;
}

- (THLViewDataSourceGrouping *)viewGrouping {
    return [THLViewDataSourceGrouping withEntityBlock:^NSString *(NSString *collection, THLEntity *entity) {
        if ([entity isKindOfClass:[THLGuestlistEntity class]])  {
            THLGuestlistEntity *guestlistEntity = (THLGuestlistEntity *)entity;
            if ([guestlistEntity.promotion.host.objectId isEqualToString:[THLUser currentUser].objectId]
                && [guestlistEntity.date thl_isOrAfterToday]) {
                return @"Guestlist Requests";
            }
        }
        return nil;
    }];
}

- (THLViewDataSourceSorting *)viewSorting {
    return [THLViewDataSourceSorting withSortingBlock:^NSComparisonResult(THLEntity *entity1, THLEntity *entity2) {
        THLGuestlistEntity *guestlist1 = (THLGuestlistEntity *)entity1;
        THLGuestlistEntity *guestlist2 = (THLGuestlistEntity *)entity2;
        return [guestlist2.date compare:guestlist1.date];
    }];
}
@end