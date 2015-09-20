//
//  THLEventFetchServiceTests.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/22/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DateTools.h"
#import "THLEventFetchService.h"
#import "Bolts.h"

@interface THLEventFetchServiceTests : XCTestCase
@property (nonatomic, strong) THLEventFetchService *fetchService;
@end

@implementation THLEventFetchServiceTests

- (void)setUp {
    [super setUp];
	_fetchService = [THLEventFetchService new];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEventsFetch {
	NSDate *currentDate = [NSDate date];
	NSDate *nextWeekDate = [currentDate dateByAddingWeeks:1];

	XCTestExpectation *expectation = [self expectationWithDescription:[NSString stringWithFormat:@"Testing %@ %@", NSStringFromClass([THLEventFetchService class]), NSStringFromSelector(@selector(fetchEventsStartingOn:endingOn:))]];
	[[_fetchService fetchEventsStartingOn:currentDate endingOn:nextWeekDate] continueWithBlock:^id(BFTask *task) {
		if (task.faulted) {
			NSLog(@"Error: %@", task.error);
			NSLog(@"Exception: %@", task.exception);
		} else {
			[expectation fulfill];
		}
		return nil;
	}];

	[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
		if (error) {
			XCTFail(@"Expectation failed with error: %@", error);
		}
	}];
}

@end
