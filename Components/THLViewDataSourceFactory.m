//
//  THLViewDataSourceFactory.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLViewDataSourceFactory.h"
#import "THLYapDatabaseViewFactory.h"
#import "THLViewDataSourceGrouping.h"
#import "THLViewDataSourceSorting.h"

#import "YapDatabaseView.h"
#import "THLViewDataSource.h"
#import "THLYapDatabaseManager.h"
#import "THLViewDataSource+Factory.h"


@implementation THLViewDataSourceFactory
- (instancetype)initWithViewFactory:(THLYapDatabaseViewFactory *)viewFactory
					databaseManager:(THLYapDatabaseManager *)databaseManager {
	if (self = [super init]) {
		_viewFactory = viewFactory;
		_databaseManager = databaseManager;
	}
	return self;
}

- (THLViewDataSource *)createDataSourceWithGrouping:(THLViewDataSourceGrouping *)grouping sorting:(THLViewDataSourceSorting *)sorting key:(NSString *)key {
	YapDatabaseViewGrouping *yapGrouping = [self yapGrouping:grouping];
	YapDatabaseViewSorting *yapSorting = [self yapSorting:sorting];
	[_viewFactory createViewWithGrouping:yapGrouping sorting:yapSorting key:key];

	YapDatabaseViewMappings *yapMappings = [[YapDatabaseViewMappings alloc] initWithGroupFilterBlock:^BOOL(NSString *group, YapDatabaseReadTransaction *transaction) {
		return YES;
	} sortBlock:^NSComparisonResult(NSString *group1, NSString *group2, YapDatabaseReadTransaction *transaction) {
		return [group1 compare:group2];
	} view:key];

	YapDatabaseConnection *yapConnection = [_databaseManager newDatabaseConnection];

	THLViewDataSource *viewDataSource = [[THLViewDataSource alloc] initWithMappings:yapMappings connection:yapConnection];
	return viewDataSource;
}

- (YapDatabaseViewGrouping *)yapGrouping:(THLViewDataSourceGrouping *)grouping {
	return [YapDatabaseViewGrouping withObjectBlock:^NSString *(YapDatabaseReadTransaction *transaction, NSString *collection, NSString *key, id object) {
		return grouping.groupingBlock(collection, object);
	}];
}

- (YapDatabaseViewSorting *)yapSorting:(THLViewDataSourceSorting *)sorting {
	return [YapDatabaseViewSorting withObjectBlock:^NSComparisonResult(YapDatabaseReadTransaction *transaction, NSString *group, NSString *collection1, NSString *key1, id object1, NSString *collection2, NSString *key2, id object2) {
		return sorting.sortingBlock(object1, object2);
	}];
}


@end
