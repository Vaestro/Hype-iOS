//
//  THLSearchViewDataSource_Private.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/8/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLSearchViewDataSource.h"
#import "THLViewDataSource_Private.h"
#import "YapDatabaseViewMappings.h"
#import "YapDatabaseSearchQueue.h"

@interface THLSearchViewDataSource ()
@property (nonatomic, readonly) YapDatabaseViewMappings *currentMappings;
@property (nonatomic, strong) YapDatabaseViewMappings *standardMappings;
@property (nonatomic, strong) YapDatabaseViewMappings *searchMappings;
@property (nonatomic, strong) YapDatabaseConnection *connection;
@property (nonatomic, strong) YapDatabaseConnection *searchConnection;
@property (nonatomic, strong) YapDatabaseSearchQueue *searchQueue;
@property (nonatomic) UITableViewRowActionStyle animationStyle;
@property (nonatomic) BOOL searching;

@property (nonatomic, copy) NSString *searchExtKey;

- (void)beginObservingChanges;
@end
