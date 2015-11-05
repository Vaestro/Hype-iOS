//
//  THLViewDataSource_Private.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLViewDataSource.h"

#import "YapDatabase.h"
#import "YapDatabaseView.h"
#import "YapDatabaseViewMappings.h"

@interface THLViewDataSource()
@property (nonatomic, strong) YapDatabaseViewMappings *mappings;
@property (nonatomic, strong) YapDatabaseConnection *connection;

- (void)beginObservingChanges;
- (void)updateEmptyView;
@end

