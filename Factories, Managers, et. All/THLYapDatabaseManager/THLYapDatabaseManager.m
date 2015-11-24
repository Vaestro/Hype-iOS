//
//  THLYapDatabaseManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLYapDatabaseManager.h"
#import <sqlite3.h>

@interface THLYapDatabaseManager ()
@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

@end

@implementation THLYapDatabaseManager
static sqlite3 *database = nil;
//static sqlite3_stmt *statement = nil;

- (instancetype)init {
	if (self = [super init]) {
		[self createDB];
	}
	return self;
}

- (void)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    NSString *databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent: @"database.sqlite"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "create table if not exists database";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
        }
        else {
            NSLog(@"Failed to open/create database");
        }
    }
    _database = [[YapDatabase alloc] initWithPath:databasePath];
}

// Phil's temporary databse code

//- (void)createDatabase {
//	NSString *databasePath = [self databasePath];
//	[[NSFileManager defaultManager] removeItemAtPath:databasePath error:NULL];
//	_database = [[YapDatabase alloc] initWithPath:databasePath];
//}
//
//- (NSString *)databasePath {
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *baseDir = ([paths count] > 0) ? paths[0] : NSTemporaryDirectory();
//	NSString *databaseName = @"database.sqlite";
//	return [baseDir stringByAppendingPathComponent:databaseName];
//}

- (YapDatabaseConnection *)newDatabaseConnection {
	return [_database newConnection];
}

@end
