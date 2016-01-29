//
//  THLEventHostingInteractor.m
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventHostingInteractor.h"

#import "THLEventHostingDataManager.h"
#import "THLEventEntity.h"
#import "THLViewDataSourceFactoryInterface.h"
#import "THLGuestlistEntity.h"

static NSString *const kTHLEventHostingModuleViewKey = @"kTHLEventHostingModuleViewKey";

@interface THLEventHostingInteractor()

@end

@implementation THLEventHostingInteractor
- (instancetype)initWithDataManager:(THLEventHostingDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    if (self = [super init]) {
        _dataManager = dataManager;
        _viewDataSourceFactory = viewDataSourceFactory;
    }
    return self;
}

- (void)updateGuestlists {
    WEAKSELF();
    [[_dataManager fetchGuestlistsForEvent:_eventEntity.objectId] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [WSELF.delegate interactor:WSELF didUpdateGuestlists:task.error];
        return nil;
    }];
}

#pragma mark - DataSource Construction
- (THLViewDataSource *)generateDataSource {
    THLViewDataSourceGrouping *grouping = [self viewGrouping];
    THLViewDataSourceSorting *sorting = [self viewSorting];
    THLViewDataSource *dataSource = [_viewDataSourceFactory createDataSourceWithGrouping:grouping sorting:sorting key:[NSString stringWithFormat:@"kTHLEventId:%@", _eventEntity.objectId]];
    return dataSource;
}

- (THLViewDataSourceGrouping *)viewGrouping {
    return [THLViewDataSourceGrouping withEntityBlock:^NSString *(NSString *collection, THLEntity *entity) {
        if ([entity isKindOfClass:[THLGuestlistEntity class]]) {
            if ([[[entity valueForKey:@"event"] valueForKey:@"objectId"] isEqualToString:_eventEntity.objectId]) {
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
        return [guestlist1.updatedAt compare:guestlist2.updatedAt];
    }];
}

@end