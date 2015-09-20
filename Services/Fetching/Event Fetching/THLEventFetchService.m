//
//  THLEventFetchService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventFetchService.h"
#import "Bolts.h"
#import "THLParseModule.h"


@implementation THLEventFetchService
- (BFTask *)fetchEventsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate {
	return [[[THLParseQueryFactory queryForEventsStartingOn:startDate endingOn:endDate] findObjectsInBackground] continueWithSuccessBlock:^id(BFTask *task) {
		NSArray *events = [(NSArray *)task.result linq_select:^id(THLParseEvent *parseEvent) {
			return [parseEvent map];
		}];
		return [BFTask taskWithResult:events];
	}];
}

@end
