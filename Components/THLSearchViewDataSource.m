//
//  THLSearchViewDataSource.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLSearchViewDataSource.h"
#import "THLSearchViewDataSource_Private.h"
#import "YapDatabaseSearchQueue.h"
#import "YapDatabaseSearchResultsViewTransaction.h"


@interface THLSearchViewDataSource()
@property (nonatomic, strong) YapDatabaseSearchQueue *searchQueue;
@end

@implementation THLSearchViewDataSource
- (void)setSearchText:(NSString *)searchText {
	_searchText = [searchText copy];
	[self performSearch];
}

- (void)performSearch {
	NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];

	NSArray *searchComponents = [self.searchText componentsSeparatedByCharactersInSet:whitespace];
	NSMutableString *query = [NSMutableString string];

	for (NSString *term in searchComponents)
	{
		if ([term length] > 0)
			[query appendString:@""];

		[query appendFormat:@"%@*", term];

	}

	YapDatabaseSearchQueue *searchQueue = self.searchQueue;
	[searchQueue enqueueQuery:query];

	[self.searchConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
		[[transaction ext:_searchExtKey] performSearchWithQueue:searchQueue];
	}];
}

#pragma mark - Lazy Instantiation
- (YapDatabaseSearchQueue *)searchQueue {
	if (!_searchQueue) {
		_searchQueue = [[YapDatabaseSearchQueue alloc] init];
	}
	return _searchQueue;
}
@end
