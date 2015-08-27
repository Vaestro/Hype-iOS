//
//  THLExtensionManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YapDatabaseExtension;
@class YapDatabaseConnection;
@class THLDatabaseManager;

@interface THLExtensionManager : NSObject
@property (nonatomic, readonly) THLDatabaseManager *databaseManager;

- (instancetype)initWithDatabaseManager:(THLDatabaseManager *)databaseManager NS_DESIGNATED_INITIALIZER;

- (void)registerExtension:(YapDatabaseExtension *)extension forKey:(NSString *)key;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) YapDatabaseConnection *newConnectionForExtension;
@end
