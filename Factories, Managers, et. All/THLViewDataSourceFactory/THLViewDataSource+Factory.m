//
//  THLViewDataSource+Factory.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLViewDataSource+Factory.h"
#import "THLViewDataSource_Private.h"

@implementation THLViewDataSource (Factory)
- (instancetype)initWithMappings:(YapDatabaseViewMappings *)mappings
					  connection:(YapDatabaseConnection *)connection {
	if (self = [super init]) {
		self.mappings = mappings;
		self.connection = connection;
		[self beginObservingChanges];
	}
	return self;
}


@end
