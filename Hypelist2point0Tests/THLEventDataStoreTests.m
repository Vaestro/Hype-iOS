//
//  THLEventDataStoreTests.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/22/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "THLEventDataStore.h"
#import "THLTestLocalModelMockFactory.h"

@interface THLEventDataStoreTests : XCTestCase
@property (nonatomic, strong) THLEventDataStore *dataStore;
@end

@implementation THLEventDataStoreTests

- (void)setUp {
    [super setUp];
	_dataStore = [THLEventDataStore sharedDataStore];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPurge {
	[_dataStore purge];
	XCTAssertEqual(_dataStore.numEntities, 0, @"Passed purge function test");
}

- (void)testEntityAddition {
	NSArray *newEntities = [THLTestLocalModelMockFactory mockLocalEvents:100];

	[_dataStore updateWithEntities:newEntities inDomain:^BOOL(THLEntity *entity) {
		return YES;
	} removeUnusedEntities:YES];
	XCTAssertEqual(_dataStore.numEntities, newEntities.count);

	[_dataStore updateWithEntities:nil inDomain:^BOOL(THLEntity *entity) {
		return YES;
	} removeUnusedEntities:NO];
	XCTAssertEqual(_dataStore.numEntities, newEntities.count);

	[_dataStore updateWithEntities:nil inDomain:^BOOL(THLEntity *entity) {
		return NO;
	} removeUnusedEntities:YES];
	XCTAssertEqual(_dataStore.numEntities, newEntities.count);

	[_dataStore updateWithEntities:@[[newEntities lastObject]] inDomain:^BOOL(THLEntity *entity) {
		return YES;
	} removeUnusedEntities:YES];
	XCTAssertEqual(_dataStore.numEntities, 1);

	[_dataStore updateWithEntities:nil inDomain:^BOOL(THLEntity *entity) {
		return YES;
	} removeUnusedEntities:YES];
	XCTAssertEqual(_dataStore.numEntities, 0);
}

- (void)testEntityRetrevial {
	[_dataStore updateWithEntities:[THLTestLocalModelMockFactory mockLocalEvents:30] inDomain:^BOOL(THLEntity *entity) {
		return YES;
	} removeUnusedEntities:NO];

	NSMutableSet *currentEntities = [NSMutableSet setWithArray:[_dataStore entitiesInDomain:^BOOL(THLEntity *entity) {
		return YES;
	}]];

	NSArray *newEntities = [THLTestLocalModelMockFactory mockLocalEvents:50];
	[_dataStore updateWithEntities:newEntities inDomain:^BOOL(THLEntity *entity) {
		return YES;
	} removeUnusedEntities:NO];

	[currentEntities addObjectsFromArray:newEntities];
	NSSet *expectedEntities = [NSSet setWithArray:[_dataStore entitiesInDomain:^BOOL(THLEntity *entity) {
		return YES;
	}]];

	XCTAssert([currentEntities isEqualToSet:expectedEntities]);

	[_dataStore updateWithEntities:newEntities inDomain:^BOOL(THLEntity *entity) {
		return YES;
	} removeUnusedEntities:YES];

	XCTAssert([[NSSet setWithArray:newEntities] isEqualToSet:[NSSet setWithArray:[_dataStore entitiesInDomain:^BOOL(THLEntity *entity) {
		return YES;
	}]]]);

}
@end
