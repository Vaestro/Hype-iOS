//
//  THLParseEventService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLParseEventService.h"
#import "THLParseModule.h"
#import "THLParseEvent.h"
#import "BFTask.h"

@implementation THLParseEventService
- (BFTask *)fetchPromotionsForEvent:(THLParseEvent *)event {
	return [[THLParseQueryFactory queryForPromotionsForEvent:event] findObjectsInBackground];
}
@end
