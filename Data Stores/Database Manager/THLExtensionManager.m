//
//  THLExtensionManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLExtensionManager.h"

#import "THLDatabaseManager.h"
#import "YapDatabaseExtension.h"

@interface THLExtensionManager()
@property (nonatomic, strong) YapDatabaseConnection *connection;
@property (nonatomic, strong) THLDatabaseManager *databaseManager;
@end

@implementation THLExtensionManager
+ (instancetype)sharedManager {
    static THLExtensionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [THLExtensionManager new];
		_sharedManager.databaseManager = [THLDatabaseManager sharedManager];
    });
    
    return _sharedManager;
}

- (THLDatabaseManager *)databaseManager {
	return [THLDatabaseManager sharedManager];
}

- (YapDatabaseConnection *)connection
{
	if (!_connection) {
		_connection = [_databaseManager newDatabaseConnection];
	}
	return _connection;
}

- (void)registerExtension:(YapDatabaseExtension *)extension forKey:(NSString *)key {
	[_databaseManager.database registerExtension:extension withName:key];
}

- (YapDatabaseConnection *)newConnectionForExtension {
	return [_databaseManager newDatabaseConnection];
}

@end
