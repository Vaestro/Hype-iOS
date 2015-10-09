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

@implementation THLSearchViewDataSource
- (void)dealloc {
	[self finishObservingChanges];

	self.cellCreationBlock = nil;
	self.cellConfigureBlock = nil;
	self.dataTransformBlock = nil;
}

- (void)beginObservingChanges {
	[_connection beginLongLivedReadTransaction];
	[_connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
		[_standardMappings updateWithTransaction:transaction];
		[_searchMappings updateWithTransaction:transaction];
	}];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(yapDatabaseModified:)
												 name:YapDatabaseModifiedNotification
											   object:_connection.database];
}

- (void)finishObservingChanges {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)yapDatabaseModified:(NSNotification *)notification {
	// Jump to the most recent commit.
	// End & Re-Begin the long-lived transaction atomically.
	// Also grab all the notifications for all the commits that I jump.
	// If the UI is a bit backed up, I may jump multiple commits.

	NSArray *notifications = [_connection beginLongLivedReadTransaction];

	// Process the notification(s),
	// and get the change-set(s) as applies to my view and mappings configuration.

	NSArray *standardSectionChanges, *standardRowChanges, *searchSectionChanges, *searchRowChanges;

	[[_connection ext:self.standardMappings.view] getSectionChanges:&standardSectionChanges
														 rowChanges:&standardRowChanges
												   forNotifications:notifications
													   withMappings:self.standardMappings];

	[[_connection ext:self.currentMappings.view] getSectionChanges:&searchSectionChanges
														rowChanges:&searchRowChanges
												  forNotifications:notifications
													  withMappings:self.searchMappings];

	NSArray *sectionChanges, *rowChanges;
	if (self.searching) {
		sectionChanges = searchSectionChanges;
		rowChanges = searchRowChanges;
	} else {
		sectionChanges = standardSectionChanges;
		rowChanges = standardRowChanges;
	}

	if (self.tableView) {
		[self.tableView beginUpdates];
		[self updateWithSectionChanges:sectionChanges rowChanges:rowChanges];
		[self.tableView endUpdates];
	} else if (self.collectionView) {
		[self.collectionView performBatchUpdates:^{
			[self updateWithSectionChanges:sectionChanges rowChanges:rowChanges];
		} completion:NULL];
	}
}

- (void)setSearching:(BOOL)searching {
	_searching = searching;
	[self reloadData];
}


- (YapDatabaseViewMappings *)currentMappings {
	if (_searching) {
		return _searchMappings;
	} else {
		return _standardMappings;
	}
}

#pragma mark - Item Accessing
- (id)untransformedItemAtIndexPath:(NSIndexPath *)indexPath {
	__block id untransformedItem;
	[_connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
		untransformedItem = [[transaction ext:self.currentMappings.view] objectAtIndexPath:indexPath withMappings:self.currentMappings];
	}];
	return untransformedItem;
}

- (id)transformedItemAtIndexPath:(NSIndexPath *)indexPath {
	id untransformedItem = [self untransformedItemAtIndexPath:indexPath];
	return (self.dataTransformBlock) ? self.dataTransformBlock(untransformedItem) : untransformedItem;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
	return [self transformedItemAtIndexPath:indexPath];
}

#pragma mark - Common

- (void)setTableView:(UITableView *)tableView {
	_tableView = tableView;

	if (tableView) {
		tableView.dataSource = self;
		_collectionView = nil;
	}

	[self updateEmptyView];
}

- (void)setCollectionView:(UICollectionView *)collectionView {
	_collectionView = collectionView;

	if (collectionView) {
		collectionView.dataSource = self;
		_tableView = nil;
	}

	[self updateEmptyView];
}

- (NSInteger)numberOfSections {
	return [self.currentMappings numberOfSections];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	return [self.currentMappings numberOfItemsInSection:section];
}

- (void)configureCell:(id)cell
			  forItem:(id)item
		   parentView:(UIScrollView *)parentView
			indexPath:(NSIndexPath *)indexPath {
	self.cellConfigureBlock(cell, item, parentView, indexPath);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	id item = [self itemAtIndexPath:indexPath];

	id cell = self.cellCreationBlock(item, tableView, indexPath);
	[self configureCell:cell
				forItem:item
			 parentView:tableView
			  indexPath:indexPath];
	return cell;
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	id item = [self itemAtIndexPath:indexPath];

	id cell = self.cellCreationBlock(item, collectionView, indexPath);
	[self configureCell:cell
				forItem:item
			 parentView:collectionView
			  indexPath:indexPath];
	return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self numberOfItemsInSection:section];
}

#pragma mark - Empty Views

- (void)setEmptyView:(UIView *)emptyView {
	if (self.emptyView) {
		[self.emptyView removeFromSuperview];
	}

	_emptyView = emptyView;
	self.emptyView.hidden = YES;

	[self updateEmptyView];
}

- (void)updateEmptyView {
	if (!self.emptyView) {
		return;
	}

	UITableView *tableView = self.tableView;
	UICollectionView *collectionView = self.collectionView;
	UIScrollView *targetView = (tableView ?: collectionView);

	if (!targetView) {
		return;
	}

	if (self.emptyView.superview != targetView) {
		[targetView addSubview:self.emptyView];
	}

	BOOL shouldShowEmptyView = ([self numberOfSections] == 0);
	BOOL isShowingEmptyView = !self.emptyView.hidden;

	if (shouldShowEmptyView) {
		if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
			tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		}
	}

	if (shouldShowEmptyView == isShowingEmptyView) {
		return;
	}

	if (CGRectEqualToRect(self.emptyView.frame, CGRectZero)) {
		CGRect frame = UIEdgeInsetsInsetRect(targetView.bounds, targetView.contentInset);

		if (tableView.tableHeaderView) {
			frame.size.height -= CGRectGetHeight(tableView.tableHeaderView.frame);
		}

		[self.emptyView setFrame:frame];
		self.emptyView.autoresizingMask = targetView.autoresizingMask;
	}

	self.emptyView.hidden = !shouldShowEmptyView;

	// Reloading seems to work around an awkward delay where the empty view
	// is not immediately visible but the separator lines still are
	if (shouldShowEmptyView) {
		[tableView reloadData];
		[collectionView reloadData];
	}
}


#pragma mark - Cell Management
- (void)updateWithSectionChanges:(NSArray *)sectionChanges rowChanges:(NSArray *)rowChanges {
	// No need to update mappings.
	// The above method did it automatically.

	if ([sectionChanges count] == 0 & [rowChanges count] == 0)
	{
		// Nothing has changed that affects our tableView
		return;
	}

	for (YapDatabaseViewSectionChange *sectionChange in sectionChanges)
	{
		switch (sectionChange.type)
		{
			case YapDatabaseViewChangeDelete :
			{
				[self deleteSectionsAtIndexes:[NSIndexSet indexSetWithIndex:sectionChange.index]];
				break;
			}
			case YapDatabaseViewChangeInsert :
			{
				[self insertSectionsAtIndexes:[NSIndexSet indexSetWithIndex:sectionChange.index]];
				break;
			}
			default: {
				break;
			}
		}
	}

	for (YapDatabaseViewRowChange *rowChange in rowChanges)
	{
		switch (rowChange.type)
		{
			case YapDatabaseViewChangeDelete :
			{
				[self deleteCellsAtIndexPaths:@[rowChange.indexPath]];
				break;
			}
			case YapDatabaseViewChangeInsert :
			{
				[self insertCellsAtIndexPaths:@[rowChange.newIndexPath]];
				break;
			}
			case YapDatabaseViewChangeMove :
			{
				[self moveCellAtIndexPath:rowChange.indexPath toIndexPath:rowChange.newIndexPath];
				break;
			}
			case YapDatabaseViewChangeUpdate :
			{
				[self reloadCellsAtIndexPaths:@[rowChange.indexPath]];
				break;
			}
		}
	}
}

- (void)insertCellsAtIndexPaths:(NSArray *)indexPaths {
	[self.tableView insertRowsAtIndexPaths:indexPaths
						  withRowAnimation:UITableViewRowAnimationMiddle];

	[self.collectionView insertItemsAtIndexPaths:indexPaths];

	[self updateEmptyView];
}

- (void)deleteCellsAtIndexPaths:(NSArray *)indexPaths {
	[self.tableView deleteRowsAtIndexPaths:indexPaths
						  withRowAnimation:UITableViewRowAnimationMiddle];

	[self.collectionView deleteItemsAtIndexPaths:indexPaths];

	[self updateEmptyView];
}

- (void)reloadCellsAtIndexPaths:(NSArray *)indexPaths {
	[self.tableView reloadRowsAtIndexPaths:indexPaths
						  withRowAnimation:UITableViewRowAnimationMiddle];

	[self.collectionView reloadItemsAtIndexPaths:indexPaths];
}

- (void)moveCellAtIndexPath:(NSIndexPath *)index1 toIndexPath:(NSIndexPath *)index2 {
	[self.tableView moveRowAtIndexPath:index1
						   toIndexPath:index2];

	[self.collectionView moveItemAtIndexPath:index1
								 toIndexPath:index2];
}

- (void)moveSectionAtIndex:(NSInteger)index1 toIndex:(NSInteger)index2 {
	[self.tableView moveSection:index1
					  toSection:index2];

	[self.collectionView moveSection:index1
						   toSection:index2];
}

- (void)insertSectionsAtIndexes:(NSIndexSet *)indexes {
	[self.tableView insertSections:indexes
				  withRowAnimation:UITableViewRowAnimationMiddle];

	[self.collectionView insertSections:indexes];

	[self updateEmptyView];
}

- (void)deleteSectionsAtIndexes:(NSIndexSet *)indexes {
	[self.tableView deleteSections:indexes
				  withRowAnimation:UITableViewRowAnimationMiddle];

	[self.collectionView deleteSections:indexes];

	[self updateEmptyView];
}

- (void)reloadSectionsAtIndexes:(NSIndexSet *)indexes {
	[self.tableView reloadSections:indexes
				  withRowAnimation:UITableViewRowAnimationMiddle];

	[self.collectionView reloadSections:indexes];
}

- (void)reloadData {
	[self.tableView reloadData];
	[self.collectionView reloadData];

	[self updateEmptyView];
}

- (void)setSearchString:(NSString *)searchString {
	NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSCharacterSet *punctuation = [NSCharacterSet punctuationCharacterSet];
	NSMutableCharacterSet *unionSet = [NSMutableCharacterSet new];
	[unionSet formUnionWithCharacterSet:whitespace];
	[unionSet formUnionWithCharacterSet:punctuation];

	NSString *strippedSearchString = [searchString stringByTrimmingCharactersInSet:unionSet];
	[self setSearching:strippedSearchString.length > 0];
	if (self.searching) {
		[self performSearchWithString:searchString];
	}
}

- (void)performSearchWithString:(NSString *)searchString {
	NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];

	NSArray *searchComponents = [searchString componentsSeparatedByCharactersInSet:whitespace];
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
@end
