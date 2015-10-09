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

@interface THLSearchViewDataSource ()
@property (nonatomic, strong) YapDatabaseViewMappings *searchMappings;
@property (nonatomic, strong) YapDatabaseConnection *searchConnection;
@property (nonatomic, copy) NSString *searchExtKey;
@end
