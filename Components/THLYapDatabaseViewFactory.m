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

@end
