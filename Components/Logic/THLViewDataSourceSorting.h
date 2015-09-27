//
//  THLViewDataSourceSorting.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEntity;
typedef NSComparisonResult(^THLViewDataSourceSortingBlock)(THLEntity *entity1, THLEntity *entity2);

@interface THLViewDataSourceSorting : NSObject
@property (nonatomic, copy, readonly) THLViewDataSourceSortingBlock sortingBlock;

+ (instancetype)withSortingBlock:(THLViewDataSourceSortingBlock)sortingBlock;
@end
