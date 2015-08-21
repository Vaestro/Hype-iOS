//
//  THLParseMapperTests.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "THLParseMappingModule.h"
#import "THLParseMapperTestsHelper.h"

@interface THLParseMapperTests : XCTestCase
@property (nonatomic, strong) THLParseMapperTestsHelper *helper;
@end

@implementation THLParseMapperTests

- (void)setUp {
    [super setUp];
	_helper = [THLParseMapperTestsHelper new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testForwardMappingEvent {
	THLParseEvent *parseEvent = [_helper mockParseEvent];
	THLEvent *localEvent = [parseEvent map];
	XCTAssert([_helper verifyParseEvent:parseEvent equalToLocalEvent:localEvent]);
}

- (void)testForwardMappingPromotion {
	THLParsePromotion *parsePromotion = [_helper mockParsePromotion];
	THLPromotion *localPromotion = [parsePromotion map];
	XCTAssert([_helper verifyParsePromotion:parsePromotion equalToLocalPromotion:localPromotion]);
}

- (void)testForwardMappingUser {
	THLParseUser *parseGuest = [_helper mockParseGuestUser];
	THLGuest *guest = (THLGuest *)[parseGuest map];
	XCTAssert([_helper verifyParseUser:parseGuest equalToLocalUser:(THLUser *)guest]);

	THLParseUser *parseHost = [_helper mockParseHostUser];
	THLHost *host = (THLHost *)[parseHost map];
	XCTAssert([_helper verifyParseUser:parseHost equalToLocalUser:(THLUser *)host]);
}

- (void)testForwardMappingLocation {
	THLParseLocation *parseLocation = [_helper mockParseLocation];
	THLLocation *localLocation = [parseLocation map];
	XCTAssert([_helper verifyParseLocation:parseLocation equalToLocalLocation:localLocation]);
}

- (void)testInverseMappingEvent {
	THLEvent *localEvent = [_helper mockLocalEvent];
	THLParseEvent *parseEvent = [THLParseEvent unmap:localEvent];
	XCTAssert([_helper verifyParseEvent:parseEvent equalToLocalEvent:localEvent]);
}

- (void)testInverseMappingPromotion {
	THLPromotion *localPromotion = [_helper mockLocalPromotion];
	THLParsePromotion *parsePromotion = [THLParsePromotion unmap:localPromotion];
	XCTAssert([_helper verifyParsePromotion:parsePromotion equalToLocalPromotion:localPromotion]);
}

- (void)testInverseMappingUser {
	THLGuest *guest = [_helper mockLocalGuest];
	THLParseUser *parseGuest = [THLParseUser unmap:(THLUser *)guest];
	XCTAssert([_helper verifyParseUser:parseGuest equalToLocalUser:(THLUser *)guest]);

	THLHost *host = [_helper mockLocalHost];
	THLParseUser *parseHost = [THLParseUser unmap:(THLUser *)host];
	XCTAssert([_helper verifyParseUser:parseHost equalToLocalUser:(THLUser *)host]);
}

- (void)testInverseMappingLocation {
	THLLocation *localLocation = [_helper mockLocalLocation];
	THLParseLocation *parseLocation = [THLParseLocation unmap:localLocation];
	XCTAssert([_helper verifyParseLocation:parseLocation equalToLocalLocation:localLocation]);
}
@end
