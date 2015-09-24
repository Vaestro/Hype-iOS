//
//  THLUserDataSyncService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/21/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserDataSyncService.h"

#import "THLUser.h"
#import "THLParseModule.h"
#import "THLParseUser.h"

@implementation THLUserDataSyncService
- (BFTask *)syncUserDataWithServer:(THLUser *)user {
	THLParseUser *updatedUser = [THLParseUser unmap:user];
	return [updatedUser saveInBackground];
}

@end
