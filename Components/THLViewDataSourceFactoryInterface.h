//
//  THLViewDataSourceFactoryInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLViewDataSource;
#import "THLViewDataSourceGrouping.h"
#import "THLViewDataSourceSorting.h"

@protocol THLViewDataSourceFactoryInterface <NSObject>
- (THLViewDataSource *)createDataSourceWithGrouping:(THLViewDataSourceGrouping *)grouping sorting:(THLViewDataSourceSorting *)sorting key:(NSString *)key;
@end
