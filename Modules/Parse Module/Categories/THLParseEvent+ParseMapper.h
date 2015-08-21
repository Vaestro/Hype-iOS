//
//  THLParseEvent+ParseMapper.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseEvent.h"
@class THLEvent;

@interface THLParseEvent (ParseMapper)
- (THLEvent *)map;
+ (instancetype)unmap:(THLEvent *)event;
@end
