//
//  THLPerkStoreInteractor.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkStoreInteractor.h"
#import "THLPerkStoreDataManager.h"
#import "THLPerkStoreItemEntity.h"
#import "THLViewDataSourceFactoryInterface.h"

static NSString *const kTHLPerksModuleViewKey = @"kTHLPerksModuleViewKey";


@interface THLPerkStoreInteractor()
@end


@implementation THLPerkStoreInteractor
- (instancetype)initWithDataManager:(THLPerkStoreDataManager *)dataManager viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    
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

- (void)refreshUserCredits {
    WEAKSELF();
    [[_dataManager fetchCreditsForUser] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        [WSELF.delegate interactor:WSELF didUpdateUserCredits:task.error];
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
        return [[NSNumber numberWithFloat:perkStoreItem1.credits] compare:[NSNumber numberWithFloat:perkStoreItem2.credits]];
    }];

}
@end
