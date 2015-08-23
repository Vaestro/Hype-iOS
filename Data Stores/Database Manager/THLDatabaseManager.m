//
//  THLDatabaseManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLDatabaseManager.h"
@interface THLDatabaseManager()
@property (nonatomic, strong) YapDatabase *database;
@end

@implementation THLDatabaseManager
+ (instancetype)sharedManager {
    static THLDatabaseManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		_sharedManager = [THLDatabaseManager new];
    });
    
    return _sharedManager;
}

- (instancetype)init {
	if (self = [super init]) {
		[self createDatabase];
	}
	return self;
}

- (void)createDatabase {
	NSString *databasePath = [self databasePath];
	[[NSFileManager defaultManager] removeItemAtPath:databasePath error:NULL];
	_database = [[YapDatabase alloc] initWithPath:databasePath];
}

- (NSString *)databasePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *baseDir = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
	NSString *databaseName = @"database.sqlite";
	return [baseDir stringByAppendingPathComponent:databaseName];
}

+ (YapDatabase *)sharedDatabase {
	return [[self sharedManager] database];
}

- (YapDatabaseConnection *)newDatabaseConnection {
	return [_database newConnection];
}

@end
