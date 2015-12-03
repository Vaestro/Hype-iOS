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
    THLViewDataSourceGrouping *grouping = [self viewGrouping];
    THLViewDataSourceSorting *sorting = [self viewSorting];
    THLViewDataSource *dataSource = [_viewDataSourceFactory createDataSourceWithGrouping:grouping sorting:sorting key:@"kTHLHostDashboardModuleViewKey"];
    return dataSource;
}

- (THLViewDataSourceGrouping *)viewGrouping {
    return [THLViewDataSourceGrouping withEntityBlock:^NSString *(NSString *collection, THLEntity *entity) {
        if ([entity isKindOfClass:[THLGuestlistEntity class]]) {
            if ([[[[entity valueForKey:@"promotion"] valueForKey:@"host"] valueForKey:@"objectId"] isEqualToString:[THLUser currentUser].objectId]) {
//                THLGuestlistEntity *guestlist = (THLGuestlistEntity *)entity;
                return collection;
            }
        }
        return nil;
    }];
}

- (THLViewDataSourceSorting *)viewSorting {
    return [THLViewDataSourceSorting withSortingBlock:^NSComparisonResult(THLEntity *entity1, THLEntity *entity2) {
        THLGuestlistEntity *guestlist1 = (THLGuestlistEntity *)entity1;
        THLGuestlistEntity *guestlist2 = (THLGuestlistEntity *)entity2;
        return [[NSNumber numberWithInteger:guestlist1.reviewStatus] compare:[NSNumber numberWithInteger:guestlist2.reviewStatus]];
    }];
}
@end