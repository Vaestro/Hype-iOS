//
//  THLDependencyManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLDependencyManager.h"

//Wireframes
#import "THLMasterWireframe.h"
#import "THLEventDiscoveryWireframe.h"

//Common
#import "THLEventDataStore.h"
#import "THLEventFetchService.h"
#import "THLExtensionManager.h"
#import "THLDatabaseManager.h"

@interface THLDependencyManager()
//Wireframes
@property (nonatomic, strong) THLMasterWireframe *masterWireframe;
@property (nonatomic, strong) THLEventDiscoveryWireframe *eventDiscoveryWireframe;

//Common
@property (nonatomic, strong) THLDatabaseManager *databaseManager;
@property (nonatomic, strong) THLExtensionManager *extensionManager;

//Data Stores
@property (nonatomic, strong) THLEventDataStore *eventDataStore;

//Services
@property (nonatomic, strong) THLEventFetchService *eventFetchService;
@end

@implementation THLDependencyManager
@synthesize eventDiscoveryWireframe = _eventDiscoveryWireframe;

#pragma mark - THLWireframeFactory
- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe {
	THLEventDiscoveryWireframe *wireframe = [[THLEventDiscoveryWireframe alloc] initWithDataStore:self.eventDataStore fetchService:self.eventFetchService extensionManager:self.extensionManager];
	self.eventDiscoveryWireframe = wireframe;
	return wireframe;
}

#pragma mark - Lazy Instantiation
#pragma mark - Wireframes
- (THLMasterWireframe *)masterWireframe {
	if (!_masterWireframe) {
		THLMasterWireframe *masterWireframe = [[THLMasterWireframe alloc] initWithFactory:self];
		_masterWireframe = masterWireframe;
	}
	return _masterWireframe;
}

#pragma mark - Common
- (THLExtensionManager *)extensionManager {
	if (!_extensionManager) {
		THLExtensionManager *extensionManager = [[THLExtensionManager alloc] initWithDatabaseManager:self.databaseManager];
		_extensionManager = extensionManager;
	}
	return _extensionManager;
}

- (THLDatabaseManager *)databaseManager {
	if (!_databaseManager) {
		THLDatabaseManager *databaseManager = [[THLDatabaseManager alloc] init];
		_databaseManager = databaseManager;
	}
	return _databaseManager;
}

#pragma mark - Data Stores
- (THLEventDataStore *)eventDataStore {
	if (!_eventDataStore) {
		THLEventDataStore *dataStore = [[THLEventDataStore alloc] initWithDatabaseManager:self.databaseManager];
		_eventDataStore = dataStore;
	}
	return _eventDataStore;
}

#pragma mark - Services
- (THLEventFetchService *)eventFetchService {
	if (!_eventFetchService) {
		THLEventFetchService *service = [[THLEventFetchService alloc] init];
		_eventFetchService = service;
	}
	return _eventFetchService;
}
@end
