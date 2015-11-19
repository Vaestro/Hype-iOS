//
//  THLEventDiscoveryInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryInteractor.h"
#import "THLEventDiscoveryDataManager.h"
#import "THLEventEntity.h"
#import "THLViewDataSourceFactoryInterface.h"

static NSString *const kTHLEventDiscoveryModuleViewKey = @"kTHLEventDiscoveryModuleViewKey";

@interface THLEventDiscoveryInteractor()
@property (nonatomic, readonly) DTTimePeriod *eventDisplayPeriod;
@end

@implementation THLEventDiscoveryInteractor
- (instancetype)initWithDataManager:(THLEventDiscoveryDataManager *)dataManager
			  viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
	if (self = [super init]) {
		_dataManager = dataManager;
		_viewDataSourceFactory = viewDataSourceFactory;
	}
	return self;
}

- (void)updateEvents {
    WEAKSELF();
    STRONGSELF();
	[[_dataManager fetchEventsFrom:self.eventDisplayPeriod.StartDate to:self.eventDisplayPeriod.EndDate] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
		[SSELF.delegate interactor:SSELF didUpdateEvents:task.error];
		return nil;
	}];
}

- (DTTimePeriod *)eventDisplayPeriod {
	return [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeWeek amount:1 startingAt:[NSDate date]];
}

#pragma mark - DataSource Construction
- (THLViewDataSource *)generateDataSource {
	THLViewDataSourceGrouping *grouping = [self viewGrouping];
	THLViewDataSourceSorting *sorting = [self viewSorting];
	THLViewDataSource *dataSource = [_viewDataSourceFactory createDataSourceWithGrouping:grouping sorting:sorting key:kTHLEventDiscoveryModuleViewKey];
	return dataSource;
}

- (THLViewDataSourceGrouping *)viewGrouping {
	return [THLViewDataSourceGrouping withEntityBlock:^NSString *(NSString *collection, THLEntity *entity) {
		if ([entity isKindOfClass:[THLEventEntity class]] && [self.eventDisplayPeriod containsDate:((THLEventEntity *)entity).date interval:DTTimePeriodIntervalOpen]) {
			return collection;
		}
		return nil;
	}];
}

- (THLViewDataSourceSorting *)viewSorting {
	return [THLViewDataSourceSorting withSortingBlock:^NSComparisonResult(THLEntity *entity1, THLEntity *entity2) {
		THLEventEntity *event1 = (THLEventEntity *)entity1;
		THLEventEntity *event2 = (THLEventEntity *)entity2;
		return [event1.date compare:event2.date];
	}];
}

@end
