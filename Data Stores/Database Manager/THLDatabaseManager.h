//
//  THLDatabaseManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YapDatabase.h"

@interface THLDatabaseManager : NSObject
@property (nonatomic, readonly) YapDatabase *database;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) YapDatabaseConnection *newDatabaseConnection;
@end
