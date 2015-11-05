//
//  THLViewDataSource+Factory.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLViewDataSource.h"

@class YapDatabaseConnection;
@class YapDatabaseViewMappings;


@interface THLViewDataSource (Factory)
- (instancetype)initWithMappings:(YapDatabaseViewMappings *)mappings
					  connection:(YapDatabaseConnection *)connection;
@end
