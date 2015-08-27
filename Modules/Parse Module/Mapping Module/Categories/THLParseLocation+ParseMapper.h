//
//  THLParseLocation+ParseMapper.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseLocation.h"
@class THLLocation;

@interface THLParseLocation (ParseMapper)
@property (NS_NONATOMIC_IOSONLY, readonly, strong) THLLocation *map;
+ (instancetype)unmap:(THLLocation *)location;
@end
