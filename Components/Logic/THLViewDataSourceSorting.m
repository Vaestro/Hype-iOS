//
//  THLViewDataSourceSorting.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLViewDataSourceSorting.h"

@implementation THLViewDataSourceSorting
+ (instancetype)withSortingBlock:(THLViewDataSourceSortingBlock)sortingBlock {
	THLViewDataSourceSorting *sorting = [[THLViewDataSourceSorting alloc] initWithSortingBlock:sortingBlock];
	return sorting;
}

- (instancetype)initWithSortingBlock:(THLViewDataSourceSortingBlock)sortingBlock {
	if (self = [super init]) {
		_sortingBlock = sortingBlock;
	}
	return self;
}
@end
