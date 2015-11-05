//
//  THLYapDatabaseViewFactory.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLYapDatabaseManager;
@class YapDatabaseViewGrouping;
@class YapDatabaseViewSorting;
@class YapDatabaseFullTextSearchHandler;

@interface THLYapDatabaseViewFactory : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly) THLYapDatabaseManager *databaseManager;
- (instancetype)initWithDatabaseManager:(THLYapDatabaseManager *)databaseManager;


- (void)createViewWithGrouping:(YapDatabaseViewGrouping *)grouping sorting:(YapDatabaseViewSorting *)sorting key:(NSString *)key;

- (void)createSearchResultsViewWithGrouping:(YapDatabaseViewGrouping *)grouping
									sorting:(YapDatabaseViewSorting *)sorting
					   fullTextSearchHander:(YapDatabaseFullTextSearchHandler *)handler
							 ftsColumnNames:(NSArray *)columnNames
									viewKey:(NSString *)viewKey
									 ftsKey:(NSString *)ftsKey;
@end
