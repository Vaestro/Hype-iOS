//
//  THLViewDataSourceFactory.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLViewDataSourceFactoryInterface.h"

@class THLYapDatabaseViewFactory;
@class THLYapDatabaseManager;

@interface THLViewDataSourceFactory : NSObject<THLViewDataSourceFactoryInterface>
#pragma mark - Dependencies
@property (nonatomic, readonly) THLYapDatabaseViewFactory *viewFactory;
@property (nonatomic, readonly) THLYapDatabaseManager *databaseManager;
- (instancetype)initWithViewFactory:(THLYapDatabaseViewFactory *)viewFactory
					databaseManager:(THLYapDatabaseManager *)databaseManager;
@end
