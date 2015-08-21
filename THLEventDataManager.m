//
//  THLEventDataManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDataManager.h"

#import "THLEventDataStore.h"
#import "THLEventFetchService.h"

@interface THLEventDataManager()
@property (nonatomic, strong) THLEventDataStore *dataStore;
@property (nonatomic, strong) THLEventFetchService *fetchService;
@end

@implementation THLEventDataManager
@synthesize delegate;

- (instancetype)initWithDataStore:(THLEventDataStore *)dataStore
					 fetchService:(THLEventFetchService *)fetchService {
	if (self = [super init]) {
		_dataStore = dataStore;
		_fetchService = fetchService;
	}
	return self;
}

- (void)updateUpcomingEvents {

}

- (void)purgeAllEvents {
	
}

- (void)cleanUpEvents {
	
}
@end
