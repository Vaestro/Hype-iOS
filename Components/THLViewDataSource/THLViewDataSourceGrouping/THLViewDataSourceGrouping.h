//
//  THLViewDataSourceGrouping.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEntity;
typedef NSString *(^THLViewDataSourceGroupingBlock)(NSString *collection, THLEntity *entity);

@interface THLViewDataSourceGrouping : NSObject
@property (nonatomic, copy, readonly) THLViewDataSourceGroupingBlock groupingBlock;

+ (instancetype)withEntityBlock:(THLViewDataSourceGroupingBlock)groupingBlock;
@end
