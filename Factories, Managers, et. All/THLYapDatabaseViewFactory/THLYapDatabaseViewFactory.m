//
//  THLYapDatabaseViewFactory.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLYapDatabaseViewFactory.h"
#import "THLYapDatabaseManager.h"
#import "YapDatabaseExtension.h"
#import "YapDatabaseView.h"
#import "YapDatabaseFullTextSearch.h"
#import "YapDatabaseSearchResultsView.h"

@implementation THLYapDatabaseViewFactory
- (instancetype)initWithDatabaseManager:(THLYapDatabaseManager *)databaseManager {
	if (self = [super init]) {
		_databaseManager = databaseManager;
	}
	return self;
}

- (void)registerExtension:(YapDatabaseExtension *)extension forKey:(NSString *)key {
	[_databaseManager.database registerExtension:extension withName:key];
}

- (void)createViewWithGrouping:(YapDatabaseViewGrouping *)grouping sorting:(YapDatabaseViewSorting *)sorting key:(NSString *)key {
	YapDatabaseView *view = [[YapDatabaseView alloc] initWithGrouping:grouping sorting:sorting];
	[self registerExtension:view forKey:key];
}

- (void)createSearchResultsViewWithGrouping:(YapDatabaseViewGrouping *)grouping
									sorting:(YapDatabaseViewSorting *)sorting
					   fullTextSearchHander:(YapDatabaseFullTextSearchHandler *)handler
							 ftsColumnNames:(NSArray *)columnNames
									viewKey:(NSString *)viewKey
									 ftsKey:(NSString *)ftsKey {


	YapDatabaseFullTextSearch *ftsExtension = [[YapDatabaseFullTextSearch alloc] initWithColumnNames:columnNames handler:handler];
	[self registerExtension:ftsExtension forKey:ftsKey];

	NSString *parentViewKey = [NSString stringWithFormat:@"%@_ParentView", viewKey];
	[self createViewWithGrouping:grouping sorting:sorting key:parentViewKey];

	YapDatabaseSearchResultsViewOptions *options = [[YapDatabaseSearchResultsViewOptions alloc] init];
	options.isPersistent = NO;
	YapDatabaseSearchResultsView *searchResultsView = [[YapDatabaseSearchResultsView alloc] initWithFullTextSearchName:ftsKey parentViewName:parentViewKey versionTag:@"1" options:options];

	[self registerExtension:searchResultsView forKey:viewKey];
}

@end
