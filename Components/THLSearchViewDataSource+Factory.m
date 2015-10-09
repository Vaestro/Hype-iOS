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
	if (self = [super initWithMappings:searchMappings connection:standardConnection]) {
		self.searchMappings = searchMappings;
		self.searchConnection = searchConnection;
		self.searchExtKey = extKey;
	}
	return self;
}

@end
