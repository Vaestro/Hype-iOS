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
#import "THLLoginWireframe.h"
#import "THLOnboardingWireframe.h"
#import "THLFacebookPictureWireframe.h"
#import "THLNumberVerificationWireframe.h"
#import "THLEventDiscoveryWireframe.h"
#import "THLEventDetailWireframe.h"
#import "THLChooseHostWireframe.h"

//Common
#import "THLExtensionManager.h"
#import "THLDatabaseManager.h"

//Data Stores
#import "THLEventDataStore.h"

//Services
#import "THLEventFetchService.h"
#import "THLFacebookProfilePictureURLFetchService.h"
#import "THLUserLoginService.h"
#import "THLParseEventService.h"


@interface THLDependencyManager()
//Wireframes
@property (nonatomic, strong) THLMasterWireframe *masterWireframe;
@property (nonatomic, strong) THLLoginWireframe *loginWireframe;
@property (nonatomic, strong) THLOnboardingWireframe *onboardingWireframe;
@property (nonatomic, strong) THLFacebookPictureWireframe *facebookPictureWireframe;
@property (nonatomic, strong) THLNumberVerificationWireframe *numberVerificationWireframe;
@property (nonatomic, strong) THLEventDiscoveryWireframe *eventDiscoveryWireframe;
@property (nonatomic, strong) THLEventDetailWireframe *eventDetailWireframe;
@property (nonatomic, strong) THLChooseHostWireframe *chooseHostWireframe;

//Common
@property (nonatomic, strong) THLDatabaseManager *databaseManager;
@property (nonatomic, strong) THLExtensionManager *extensionManager;

//Data Stores
@property (nonatomic, strong) THLEventDataStore *eventDataStore;

//Services
@property (nonatomic, strong) THLEventFetchService *eventFetchService;
@property (nonatomic, strong) THLFacebookProfilePictureURLFetchService *facebookProfilePictureURLFetchService;
@property (nonatomic, strong) THLUserLoginService *userLoginService;
@property (nonatomic, strong) THLParseEventService *eventService;
@end

@implementation THLDependencyManager

#pragma mark - THLWireframeFactory
- (THLLoginWireframe *)newLoginWireframe {
	THLLoginWireframe *wireframe = [[THLLoginWireframe alloc] initWithLoginService:self.userLoginService];
	self.loginWireframe = wireframe;
	return wireframe;
}

- (THLOnboardingWireframe *)newOnboardingWireframe {
	THLOnboardingWireframe *wireframe = [[THLOnboardingWireframe alloc] initWithFacebookPictureModule:[self newFacebookPictureWireframe].moduleInterface
																			 numberVerificationModule:[self newNumberVerificationWireframe].moduleInterface];
	self.onboardingWireframe = wireframe;
	return wireframe;
}

- (THLFacebookPictureWireframe *)newFacebookPictureWireframe {
	THLFacebookPictureWireframe *wireframe = [[THLFacebookPictureWireframe alloc] initWithFetchService:self.facebookProfilePictureURLFetchService];
	self.facebookPictureWireframe = wireframe;
	return wireframe;
}

- (THLNumberVerificationWireframe *)newNumberVerificationWireframe {
	THLNumberVerificationWireframe *wireframe = [[THLNumberVerificationWireframe alloc] init];
	self.numberVerificationWireframe = wireframe;
	return wireframe;
}

- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe {
	THLEventDiscoveryWireframe *wireframe = [[THLEventDiscoveryWireframe alloc] initWithDataStore:self.eventDataStore fetchService:self.eventFetchService extensionManager:self.extensionManager];
	self.eventDiscoveryWireframe = wireframe;
	return wireframe;
}

- (THLEventDetailWireframe *)newEventDetailWireframe {
	THLEventDetailWireframe *wireframe = [[THLEventDetailWireframe alloc] init];
	self.eventDetailWireframe = wireframe;
	return wireframe;
}

- (THLChooseHostWireframe *)newChooseHostWireframe {
	THLChooseHostWireframe *wireframe = [[THLChooseHostWireframe alloc] initWithEventService:self.eventService];
	self.chooseHostWireframe = wireframe;
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

- (THLFacebookProfilePictureURLFetchService *)facebookProfilePictureURLFetchService {
	if (!_facebookProfilePictureURLFetchService) {
		THLFacebookProfilePictureURLFetchService *service = [[THLFacebookProfilePictureURLFetchService alloc] init];
		_facebookProfilePictureURLFetchService = service;
	}
	return _facebookProfilePictureURLFetchService;
}

- (THLUserLoginService *)userLoginService {
	if (!_userLoginService) {
		THLUserLoginService *service = [[THLUserLoginService alloc] init];
		_userLoginService = service;
	}
	return _userLoginService;
}

- (THLParseEventService *)eventService {
	if (!_eventService) {
		THLParseEventService *service = [[THLParseEventService alloc] init];
		_eventService = service;
	}
	return _eventService;
}
@end
