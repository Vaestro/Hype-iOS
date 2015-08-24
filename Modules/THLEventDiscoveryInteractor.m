//
//  THLEventDiscoveryInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryInteractor.h"
#import "THLViewDataSource.h"
#import "THLEventDiscoveryDataManager.h"
#import "YapDatabase.h"
#import "YapDatabaseView.h"
#import "THLEvent.h"
#import "THLViewDataSource.h"
#import "YapDatabaseViewMappings.h"
#import "THLExtensionManager.h"

static NSString *const kTHLEventDiscoveryModuleViewKey = @"kTHLEventDiscoveryModuleViewKey";

@interface THLEventDiscoveryInteractor()
@property (nonatomic, readonly) DTTimePeriod *eventDisplayPeriod;
@end

@implementation THLEventDiscoveryInteractor
- (instancetype)initWithDataManager:(THLEventDiscoveryDataManager *)dataManager
				   extensionManager:(THLExtensionManager *)extensionManager {
	if (self = [super init]) {
		_dataManager = dataManager;
		_extensionManager = extensionManager;
	}
	return self;
}

- (DTTimePeriod *)eventDisplayPeriod {
	return [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeWeek amount:1 startingAt:[NSDate date]];
}


#pragma mark - DataSource Construction
- (THLViewDataSource *)generateDataSource {
	YapDatabaseView *view = [self createView];
	[self registerView:view];
	THLViewDataSource *dataSource = [[THLViewDataSource alloc] initWithMappings:[self viewMappings] connection:[_extensionManager newConnectionForExtension]];
	return dataSource;
}

- (YapDatabaseView *)createView {
	YapDatabaseViewGrouping *grouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(YapDatabaseReadTransaction *transaction, NSString *collection, NSString *key, id object) {
		THLEvent *event = (THLEvent *)object;
		if ([self.eventDisplayPeriod containsDate:event.date interval:DTTimePeriodIntervalOpen]) {
			return collection;
		}
		return nil;
	}];

	YapDatabaseViewSorting *sorting = [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(YapDatabaseReadTransaction *transaction, NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
		THLEvent *event1 = (THLEvent *)object1;
		THLEvent *event2 = (THLEvent *)object2;
		return [event1.date compare:event2.date];
	}];

	YapDatabaseView *view = [[YapDatabaseView alloc] initWithGrouping:grouping sorting:sorting];
	return view;
}

- (void)registerView:(YapDatabaseView *)view {
	[_extensionManager registerExtension:view forKey:kTHLEventDiscoveryModuleViewKey];
}

- (YapDatabaseViewMappings *)viewMappings {
	YapDatabaseViewMappings *mappings = [[YapDatabaseViewMappings alloc] initWithGroupFilterBlock:^BOOL(NSString *group, YapDatabaseReadTransaction *transaction) {
		return YES;
	} sortBlock:^NSComparisonResult(NSString *group1, NSString *group2, YapDatabaseReadTransaction *transaction) {
		return [group1 compare:group2];
	} view:kTHLEventDiscoveryModuleViewKey];
	return mappings;
}
@end
