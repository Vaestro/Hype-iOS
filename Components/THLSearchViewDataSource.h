//
//  THLSearchViewDataSource.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLViewDataSource.h"
@class YapDatabaseConnection;

@interface THLSearchViewDataSource : THLViewDataSource
@property (nonatomic, copy) NSString *searchText;
@end
