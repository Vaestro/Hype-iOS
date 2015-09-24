//
//  THLUserDataSyncService.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/21/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BFTask;
@class THLUser;

@interface THLUserDataSyncService : NSObject
- (BFTask *)syncUserDataWithServer:(THLUser *)user;
@end
