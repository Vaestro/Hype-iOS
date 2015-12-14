//
//  THLPerkInteractor.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkInteractor.h"
#import "THLPerkDataManager.h"
#import "THLPerkStoreItemEntity.h"
#import "THLViewDataSourceFactoryInterface.h"

static NSString *const kTHLPerksModuleViewKey = @"kTHLPerksModuleViewKey";


@interface THLPerkInteractor()
@end


@implementation THLPerkInteractor
- (instancetype)initWithDataManager:(THLPerkDataManager *)dataManager viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    
    if (self = [super init]) {
        _dataManager = dataManager;
        _viewDataSourceFactory = viewDataSourceFactory;
    }
    return self;
}

- (void)updatePerks {
    WEAKSELF();
    [[_dataManager fetchAllPerkStoreItems] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [WSELF.delegate interactor:WSELF didUpdatePerks:task.error];
        return nil;
    }];
}

#pragma mark - DataSource Construction
- (THLViewDataSource *)generateDataSource {
    THLViewDataSourceGrouping *grouping = [self viewGrouping];
    THLViewDataSourceSorting *sorting = [self viewSorting];
    THLViewDataSource *dataSource = [_viewDataSourceFactory createDataSourceWithGrouping:grouping sorting:sorting key:kTHLPerksModuleViewKey];
    return dataSource;
}

- (THLViewDataSourceGrouping *)viewGrouping {
    return [THLViewDataSourceGrouping withEntityBlock:^NSString *(NSString *collection, THLEntity *entity) {
        if ([entity isKindOfClass:[THLPerkStoreItemEntity class]]) {
            return collection;
        }
        return nil;
    }];
}

- (THLViewDataSourceSorting *)viewSorting {
    return [THLViewDataSourceSorting withSortingBlock:^NSComparisonResult(THLEntity *entity1, THLEntity *entity2) {
        THLPerkStoreItemEntity *perkStoreItem1 = (THLPerkStoreItemEntity *)entity1;
        THLPerkStoreItemEntity *perkStoreItem2 = (THLPerkStoreItemEntity *)entity2;
        return [perkStoreItem1.name compare:perkStoreItem2.name];
    }];

}
@end