//
//  THLSearchViewDataSource+Factory.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLSearchViewDataSource.h"
@class YapDatabaseConnection;
@class YapDatabaseViewMappings;

@interface THLSearchViewDataSource (Factory)
- (instancetype)initWithStandardMappings:(YapDatabaseViewMappings *)standardMappings
							 searchMappings:(YapDatabaseViewMappings *)searchMappings
					  standardConnection:(YapDatabaseConnection *)standardConnection
						searchConnection:(YapDatabaseConnection *)searchConnection
						 searchExtensionKey:(NSString *)extKey;

@end
