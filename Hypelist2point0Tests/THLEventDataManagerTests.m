//
//  THLEventDataManagerTests.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "THLEventDataManager.h"
#import "THLEventFetchService.h"
#import "THLEventDataStore.h"
#import "OCMock.h"
#import "THLTestLocalModelMockFactory.h"
#import "Bolts.h"

@interface THLEventDataManagerTests : XCTestCase
@property (nonatomic, strong) THLEventDataManager *dataManager;
@end

@implementation THLEventDataManagerTests

- (void)setUp {
    [super setUp];
	id eventFetchServiceMock = OCMClassMock([THLEventFetchService class]);
	NSArray *randEvents = [THLTestLocalModelMockFactory mockLocalEvents:30];
	BFTask *fetchResults = [BFTask taskWithResult:randEvents];
	OCMStub([eventFetchServiceMock fetchEventsStartingOn:[OCMArg any] endingOn:[OCMArg any]]).andReturn(fetchResults);

	id eventDataStoreMock = OCMClassMock([THLEventDataStore class]);

	_dataManager = [[THLEventDataManager alloc] initWithDataStore:eventDataStoreMock
																		fetchService:eventFetchServiceMock];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUpdateUpcomingEvents {
	[_dataManager updateUpcomingEvents];
}

- (void)testPurgeAllEvents {
	[_dataManager purgeAllEvents];
	NSArray *remainingEvents = [_dataManager.dataStore entitiesInDomain:^BOOL(THLEntity *entity) {
		return YES;
	}];

	XCTAssert(remainingEvents.count == 0);
}

- (void)testCleanupEvents {
	[_dataManager cleanUpEvents];
}

@end
