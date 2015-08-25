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

@end

@implementation THLExtensionManager
- (instancetype)initWithDatabaseManager:(THLDatabaseManager *)databaseManager {
	if (self = [super init]) {
		_databaseManager = databaseManager;
	}
	return self;
}

- (YapDatabaseConnection *)connection {
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
