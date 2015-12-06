//
//  THLViewDataSource.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLViewDataSource.h"
#import "THLViewDataSource_Private.h"
#import "THLDashboardNotificationSectionTitleCell.h"
#import "THLAppearanceConstants.h"

@implementation THLViewDataSource
- (void)dealloc {
	[self finishObservingChanges];

	self.cellCreationBlock = nil;
	self.cellConfigureBlock = nil;
	self.dataTransformBlock = nil;
}

- (void)beginObservingChanges {
    WEAKSELF();
	[_connection beginLongLivedReadTransaction];
    
    [_mappings setIsDynamicSectionForAllGroups:NO];
    
	[_connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
		[WSELF.mappings updateWithTransaction:transaction];
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
//    if ([notifications count] == 0) {
//        return; // already processed commit
//    }
    
    // Check to see if I need to do anything
    if ( ! [[_connection ext:_mappings.view] hasChangesForNotifications:notifications])
    {
        // Sweet.
        // Just update my mappings so it's on the same snapshot as my connection, and I'm done.
        [_connection readWithBlock:^(YapDatabaseReadTransaction *transaction){
            [_mappings updateWithTransaction:transaction];
        }];
        return; // Good to go :)
    }
    
	// Process the notification(s),
	// and get the change-set(s) as applies to my view and mappings configuration.
	NSArray *sectionChanges = nil;
	NSArray *rowChanges = nil;
    
	[[_connection ext:_mappings.view] getSectionChanges:&sectionChanges
                                             rowChanges:&rowChanges
                                       forNotifications:notifications
                                           withMappings:_mappings];
    WEAKSELF();
	if (self.tableView) {
		[self.tableView beginUpdates];
		[self updateWithSectionChanges:sectionChanges rowChanges:rowChanges];
		[self.tableView endUpdates];
	} else if (self.collectionView) {
		[self.collectionView performBatchUpdates:^{
			[WSELF updateWithSectionChanges:sectionChanges rowChanges:rowChanges];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        } ];
	}
}

#pragma mark - Item Accessing
- (id)untransformedItemAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF();
	__block id untransformedItem;
	[_connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
		untransformedItem = [[transaction ext:[WSELF mappings].view]	objectAtIndexPath:indexPath withMappings:WSELF.mappings];
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
	return [_mappings numberOfSections];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	return [_mappings numberOfItemsInSection:section];
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
    // The section is which group?
    // Mappings can tell us...
//    NSString *group = [_mappings groupForSection:indexPath.section];
    
	id item = [self itemAtIndexPath:indexPath];

	id cell = self.cellCreationBlock(item, tableView, indexPath);
	[self configureCell:cell
				forItem:item
			 parentView:tableView
			  indexPath:indexPath];
	return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    NSLog(@"NUMBER OF SECTIONS IN %@ IS: %ld", self, [self numberOfSections]);
    return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItemsInSection:section];
}

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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        THLDashboardNotificationSectionTitleCell *titleHeaderCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                       withReuseIdentifier:[THLDashboardNotificationSectionTitleCell identifier]
                                                                                                              forIndexPath:indexPath];
        NSString *title = [_mappings groupForSection:indexPath.section];
        titleHeaderCell.titleText = title;
        titleHeaderCell.tintColor = kTHLNUIPrimaryFontColor;
        titleHeaderCell.backgroundColor = kTHLNUIPrimaryBackgroundColor;
        CGRect frame = titleHeaderCell.frame;
        frame.size.height = 40;
        [titleHeaderCell setFrame:frame];
        reusableview = titleHeaderCell;
    }
    else if (kind == UICollectionElementKindSectionFooter) {
        THLDashboardNotificationSectionTitleCell *titleHeaderCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                       withReuseIdentifier:[THLDashboardNotificationSectionTitleCell identifier]
                                                                                                              forIndexPath:indexPath];
        NSString *title = @"Pending Guestlist Invites";
        titleHeaderCell.titleText = title;
        titleHeaderCell.backgroundColor = kTHLNUIRedColor;
        reusableview = titleHeaderCell;
    }
    return reusableview;
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
//    NSMutableArray *newSections = [NSMutableArray new];

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
//                [newSections addObject:[NSNumber numberWithInteger:sectionChange.index]];
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
            default: {
                break;
            }
		}
	}
}

//- (void)moveSectionAtIndex:(NSInteger)index1 toIndex:(NSInteger)index2 {
//	[self.tableView moveSection:index1
//					  toSection:index2];
//
//	[self.collectionView moveSection:index1
//						   toSection:index2];
//}

- (void)insertSectionsAtIndexes:(NSIndexSet *)indexes {
    if (self.tableView) {
        [self.tableView insertSections:indexes
                      withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    if (self.collectionView) {
        [self.collectionView insertSections:indexes];
    }
	[self updateEmptyView];
}

- (void)deleteSectionsAtIndexes:(NSIndexSet *)indexes {
    if (self.tableView) {
        [self.tableView deleteSections:indexes
                      withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    if (self.collectionView) {
        [self.collectionView deleteSections:indexes];
    }

	[self updateEmptyView];
}

- (void)reloadSectionsAtIndexes:(NSIndexSet *)indexes {
    if (self.tableView) {
        [self.tableView reloadSections:indexes
                      withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if (self.collectionView) {
        [self.collectionView reloadSections:indexes];
    }
}

- (void)insertCellsAtIndexPaths:(NSArray *)indexPaths {
    if (self.tableView) {
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if (self.collectionView) {
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
        
    }
    
    [self updateEmptyView];
}

- (void)deleteCellsAtIndexPaths:(NSArray *)indexPaths {
    if (self.tableView) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if (self.collectionView) {
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    }
    
    [self updateEmptyView];
}

- (void)reloadCellsAtIndexPaths:(NSArray *)indexPaths {
    if (self.tableView) {
        [self.tableView reloadRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if (self.collectionView) {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }
}

- (void)moveCellAtIndexPath:(NSIndexPath *)index1 toIndexPath:(NSIndexPath *)index2 {
//    if (self.tableView) {
        [self deleteCellsAtIndexPaths:@[index1]];
        [self insertCellsAtIndexPaths:@[index2]];
//        NSLog(@"Old index: %ld, New Index: %ld", index1.section, index2.section);
//    }
//    if (self.collectionView) {
//        [self.collectionView moveItemAtIndexPath:index1
//								 toIndexPath:index2];
//    }
}

- (void)reloadData {
    if (self.tableView) {
        [self.tableView reloadData];
    }
    
    if (self.collectionView) {
        [self.collectionView reloadData];
    }

	[self updateEmptyView];
}

@end
