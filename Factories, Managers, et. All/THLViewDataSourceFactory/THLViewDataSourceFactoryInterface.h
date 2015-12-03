//
//  THLViewDataSourceFactoryInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLViewDataSource;
@class THLSearchViewDataSource;

#import "THLViewDataSourceGrouping.h"
#import "THLViewDataSourceSorting.h"
#import "THLSearchResultsViewDataSourceHandler.h"

@protocol THLViewDataSourceFactoryInterface <NSObject>
- (THLViewDataSource *)createDataSourceWithGrouping:(THLViewDataSourceGrouping *)grouping
											sorting:(THLViewDataSourceSorting *)sorting
												key:(NSString *)key;

- (THLSearchViewDataSource *)createSearchDataSourceWithGrouping:(THLViewDataSourceGrouping *)grouping
														sorting:(THLViewDataSourceSorting *)sorting
														handler:(THLSearchResultsViewDataSourceHandler *)handler
										   searchableProperties:(NSArray *)properties
															key:(NSString *)key;

- (THLViewDataSource *)createDataSourceWithFixedGrouping:(THLViewDataSourceGrouping *)grouping
                                                 sorting:(THLViewDataSourceSorting *)sorting
                                                  groups:(NSArray *)groups
                                                     key:(NSString *)key;

@end
