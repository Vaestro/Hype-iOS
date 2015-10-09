//
//  THLSearchViewDataSource+Factory.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLSearchViewDataSource+Factory.h"
#import "THLSearchViewDataSource_Private.h"
#import "THLViewDataSource+Factory.h"

@implementation THLSearchViewDataSource (Factory)
- (instancetype)initWithStandardMappings:(YapDatabaseViewMappings *)standardMappings
							 searchMappings:(YapDatabaseViewMappings *)searchMappings
					  standardConnection:(YapDatabaseConnection *)standardConnection
						searchConnection:(YapDatabaseConnection *)searchConnection
						 searchExtensionKey:(NSString *)extKey {
	if (self = [super init]) {
		self.standardMappings = standardMappings;
		self.searchMappings = searchMappings;
		self.connection = standardConnection;
		self.searchConnection = searchConnection;
		self.searchExtKey = extKey;
		self.searchQueue = [[YapDatabaseSearchQueue alloc] init];
		[self beginObservingChanges];
	}
	return self;
}

@end
