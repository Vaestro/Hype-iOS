//
//  THLViewDataSourceGrouping.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLViewDataSourceGrouping.h"

@implementation THLViewDataSourceGrouping
+ (instancetype)withEntityBlock:(THLViewDataSourceGroupingBlock)groupingBlock {
	THLViewDataSourceGrouping *grouping = [[THLViewDataSourceGrouping alloc] initWithEntityBlock:groupingBlock];
	return grouping;
}

- (instancetype)initWithEntityBlock:(THLViewDataSourceGroupingBlock)groupingBlock {
	if (self = [super init]) {
		_groupingBlock = groupingBlock;
	}
	return self;
}
@end
