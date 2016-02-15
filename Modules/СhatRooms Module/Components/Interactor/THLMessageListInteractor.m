//
//  THLMessageListInteractor.m
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListInteractor.h"
#import "THLViewDataSource.h"
#import "THLViewDataSourceGrouping.h"
#import "THLViewDataSourceSorting.h"
#import "THLMessageListEntity.h"
#import "THLPubnubManager.h"
#import "THLViewDataSource+Factory.h"
#import "YapDatabaseViewMappings.h"

@implementation THLMessageListInteractor

- (instancetype)initWithDataManager:(THLMessageListDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    if (self = [super init]) {
        _dataManager = dataManager;
        _viewDataSourceFactory = viewDataSourceFactory;
        //_dataManager.delegate = self;
    }
    return self;
}

#pragma mark - DataSource Construction
- (THLViewDataSource *)generateDataSource {
    THLViewDataSourceGrouping *grouping = [self viewGrouping];
    THLViewDataSourceSorting *sorting = [self viewSorting];
    THLViewDataSource *dataSource = [_viewDataSourceFactory createDataSourceWithGrouping:grouping sorting:sorting key:@"lastMessage"];
    return dataSource;
}

- (THLViewDataSource *)generateMessageDataSource {
//    THLViewDataSourceGrouping *grouping = [self viewGrouping];
//    THLViewDataSourceSorting *sorting = [self viewSorting];
//    THLViewDataSource *dataSource = [_viewDataSourceFactory createDataSourceWithGrouping:grouping sorting:sorting key:@"lastMessage"];
    THLViewDataSource *viewDataSource = [[THLViewDataSource alloc] initWithMappings:[YapDatabaseViewMappings mappingsWithGroups:@[@"qwerty", @"asdfg"] view:@"view"]
                                                                         connection:nil];
    return viewDataSource;
}

- (THLViewDataSourceGrouping *)viewGrouping {
    return [THLViewDataSourceGrouping withEntityBlock:^NSString *(NSString *collection, THLEntity *entity) {
        if ([entity isKindOfClass:[THLMessageListEntity class]]) {
            return collection;
        }
        return nil;
    }];
}

- (THLViewDataSourceSorting *)viewSorting {
    return [THLViewDataSourceSorting withSortingBlock:^NSComparisonResult(THLEntity *entity1, THLEntity *entity2) {
        THLMessageListEntity *messageList1 = (THLMessageListEntity *)entity1;
        THLMessageListEntity *messageList2 = (THLMessageListEntity *)entity2;
        return [[NSNumber numberWithFloat:messageList1.time.floatValue] compare:[NSNumber numberWithFloat:messageList2.time.floatValue]];
    }];
    
}

- (void)updateChannels {
    WEAKSELF();
    [[_dataManager fetchAllChannels] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull task) {
        [WSELF.delegate interactor:WSELF didUpdateChannels:nil];
        return nil;
    }];
    
//    [[_dataManager fetchAllChannels] continueWithSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
//        [WSELF.delegate interactor:WSELF didUpdateChannels:nil];
//        return nil;
//    }];
    
//    [[_dataManager fetchAllChannels] continueWithExecutor:[BFExecutor mainThreadExecutor] withSuccessBlock:^id _Nullable(BFTask * _Nonnull task) {
//        //
//        return nil;
//    }];
    
}

@end
