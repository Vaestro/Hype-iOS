//
//  THLEntityMapper.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLUser;
@class THLGuestEntity;

@interface THLEntityMapper : NSObject
- (THLGuestEntity *)mapGuest:(THLUser *)user;


@end
