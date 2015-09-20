//
//  THLEventDiscoveryInteractorTests.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "THLEventDiscoveryInteractor.h"
#import "THLExtensionManager.h"
#import "THLEventDiscoveryDataManager.h"
#import "OCMock.h"
#import "THLViewDataSource.h"

@interface THLEventDiscoveryInteractorTests : XCTestCase
@property (nonatomic, strong) THLEventDiscoveryInteractor *interactor;
@end

@implementation THLEventDiscoveryInteractorTests

- (void)setUp {
    [super setUp];
	THLExtensionManager *extensionManager = nil;
	id dataManagerMock = OCMClassMock([THLEventDiscoveryDataManager class]);
	THLEventDiscoveryInteractor *interactor = [[THLEventDiscoveryInteractor alloc] initWithDataManager:dataManagerMock extensionManager:extensionManager];
	_interactor = interactor;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGenerateDataSource {
	THLViewDataSource *dataSource = [_interactor generateDataSource];
	XCTAssertNotNil(dataSource);
}


@end
