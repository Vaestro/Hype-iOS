//
//  THLViewDataSource.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>


@class YapDatabaseView;
@class YapDatabaseConnection;
@class YapDatabaseViewMappings;

typedef id (^THLDataTransformBlock)(id item);


// Block called to configure each table and collection cell.
typedef void (^THLCellConfigureBlock) (id cell,                 // The cell to configure
									   id object,               // The object being presented in this cell
									   id parentView,           // The parent table or collection view
									   NSIndexPath *indexPath); // Index path for this cell

// Optional block used to create a table or collection cell.
typedef id   (^THLCellCreationBlock)  (id object,               // The object being presented in this cell
									   id parentView,           // The parent table or collection view
									   NSIndexPath *indexPath); // Index path for this cell

@interface THLViewDataSource : NSObject
<UITableViewDataSource,
UICollectionViewDataSource>

@property (nonatomic, readonly) YapDatabaseViewMappings *mappings;
@property (nonatomic, readonly) YapDatabaseConnection *connection;

@property (nonatomic, copy) THLDataTransformBlock dataTransformBlock;
@property (nonatomic, copy) THLCellCreationBlock cellCreationBlock;
@property (nonatomic, copy) THLCellConfigureBlock cellConfigureBlock;

/**
 * Optional view that will be added to the table or collection view if there
 * are no items in the datasource, then removed again once the datasource
 * has items.
 *
 * If this view's frame is equal to CGRectZero, the view's frame
 * will be sized to match the parent table or collection view.
 */
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UITableView *tableView;

- (instancetype)initWithMappings:(YapDatabaseViewMappings *)mappings
						connection:(YapDatabaseConnection *)connection NS_DESIGNATED_INITIALIZER;

- (id)untransformedItemAtIndexPath:(NSIndexPath *)indexPath;
//- (NSInteger)numberOfSections;
//- (NSInteger)numberOfItemsInSection:(NSInteger)section;
//- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
//- (NSIndexPath *)indexPathForItem:(id)item;
@end
