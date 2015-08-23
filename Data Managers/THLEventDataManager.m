//
//  THLEventDataManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDataManager.h"

#import "THLEventDataStore.h"
#import "THLEventFetchServiceInterface.h"
#import "THLEvent.h"

@interface THLEventDataManager()
@property (nonatomic, strong) THLEventDataStore *dataStore;
@property (nonatomic, strong) id<THLEventFetchServiceInterface> fetchService;
@end

@implementation THLEventDataManager
@synthesize delegate;

- (instancetype)initWithDataStore:(THLEventDataStore *)dataStore
					 fetchService:(id<THLEventFetchServiceInterface>)fetchService {
	if (self = [super init]) {
		_dataStore = dataStore;
		_fetchService = fetchService;
	}
	return self;
}

- (void)updateUpcomingEvents {
	__block NSDate *startDate = [NSDate date];
	__block NSDate *endDate = [startDate dateByAddingWeeks:1];

	[[_fetchService fetchEventsStartingOn:startDate endingOn:endDate] continueWithSuccessBlock:^id(BFTask *task) {
		[_dataStore updateWithEntities:task.result inDomain:^BOOL(THLEntity *entity) {
			THLEvent *event = (THLEvent *)entity;
			return ([event.date isLaterThanOrEqualTo:startDate] &&
					[event.date isEarlierThanOrEqualTo:endDate]);
		}];

		if ([self.delegate respondsToSelector:@selector(eventDataManagerDidUpdateUpcomingEvents:)]) {
			[self.delegate eventDataManagerDidUpdateUpcomingEvents:self];
		}
		return nil;
	}];
}

- (void)purgeAllEvents {
	[_dataStore purge];
}

- (void)cleanUpEvents {
	__block NSDate *startDate = [NSDate date];
	__block NSDate *endDate = [startDate dateByAddingWeeks:1];

	[_dataStore removeEntitiesInDomain:^BOOL(THLEntity *entity) {
		THLEvent *event = (THLEvent *)entity;
		BOOL eventWithinNextWeek = ([event.date isLaterThanOrEqualTo:startDate] &&
									[event.date isEarlierThanOrEqualTo:endDate]);
		return !eventWithinNextWeek;
	}];
}
@end
