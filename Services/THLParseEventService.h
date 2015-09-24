//
//  THLParseEventService.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;
@class THLParseEvent;
@interface THLParseEventService : NSObject
- (BFTask *)fetchPromotionsForEvent:(THLParseEvent *)event;
@end
