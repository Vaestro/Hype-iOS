//
//  THLSearchResultsViewDataSourceHandler.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLSearchResultsViewDataSourceHandler.h"

@implementation THLSearchResultsViewDataSourceHandler
+ (instancetype)withBlock:(THLSearchResultsViewDataSourceHandlerBlock)block {
	THLSearchResultsViewDataSourceHandler *handler = [[THLSearchResultsViewDataSourceHandler alloc] initWithBlock:block];
	return handler;
}

- (instancetype)initWithBlock:(THLSearchResultsViewDataSourceHandlerBlock)block {
	if (self = [super init]) {
		_handlerBlock = block;
	}
	return self;
}

@end
