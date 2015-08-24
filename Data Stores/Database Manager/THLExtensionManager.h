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

@interface THLExtensionManager : NSObject
+ (instancetype)sharedManager;

- (void)registerExtension:(YapDatabaseExtension *)extension forKey:(NSString *)key;
- (YapDatabaseConnection *)newConnectionForExtension;
@end
