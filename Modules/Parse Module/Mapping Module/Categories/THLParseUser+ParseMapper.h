//
//  THLParseUser+ParseMapper.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseUser.h"
@class THLUser;

@interface THLParseUser (ParseMapper)
@property (NS_NONATOMIC_IOSONLY, readonly, strong) THLUser *map;
+ (THLParseUser *)unmap:(THLUser *)user;
@end
