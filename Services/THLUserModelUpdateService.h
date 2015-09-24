//
//  THLUserModelUpdateService.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/21/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLUser;
@class BFTask;

@interface THLUserModelUpdateService : NSObject
- (BFTask *)updateUser:(THLUser *)user withPhoneNumber:(NSString *)phoneNumber;
- (BFTask *)updateUser:(THLUser *)user withProfileImage:(UIImage *)image;
@end
