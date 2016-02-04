//
//  THLDependencyManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLDependencyManager.h"

//Dependency Management Protocols
#import "THLGuestFlowDependencyManager.h"
#import "THLHostFlowDependencyManager.h"

//Wireframes
#import "THLMasterWireframe.h"
#import "THLLoginWireframe.h"
#import "THLFacebookPictureWireframe.h"
#import "THLNumberVerificationWireframe.h"
#import "THLGuestFlowWireframe.h"
#import "THLHostFlowWireframe.h"

#import "THLMessageListWireframe.h"
#import "THLEventDiscoveryWireframe.h"
#import "THLDashboardWireframe.h"
#import "THLHostDashboardWireframe.h"
#import "THLEventDetailWireframe.h"
#import "THLUserProfileWireframe.h"
#import "THLEventHostingWireframe.h"
#import "THLGuestlistInvitationWireframe.h"
#import "THLGuestlistReviewWireframe.h"
#import "THLPopupNotificationWireframe.h"
#import "THLPerkStoreWireframe.h"
#import "THLPerkDetailWireframe.h"
#import "THLWaitlistPresenter.h"

//Common
//#import "THLPushNotificationManager.h"
#import "THLYapDatabaseManager.h"
#import "THLEntityMapper.h"
#import "THLViewDataSourceFactory.h"
#import "THLParseQueryFactory.h"
#import "THLYapDatabaseViewFactory.h"
#import "THLUserManager.h"
#import "APAddressBook.h"

//Data Stores
#import "THLDataStore.h"

//Services
#import "THLLoginService.h"
#import "THLEventService.h"
#import "THLLocationService.h"
#import "THLFacebookProfilePictureURLFetchService.h"
#import "THLGuestlistService.h"
#import "THLPerkStoreItemService.h"

//Classes
#import "THLEntities.h"
#import "THLGuestEntity.h"
#import "THLGuestlistInviteEntity.h"
#import "THLPerkStoreItemEntity.h"




@interface THLDependencyManager()
//Wireframes
@property (nonatomic, strong) THLMasterWireframe *masterWireframe;
@property (nonatomic, weak) THLLoginWireframe *loginWireframe;
@property (nonatomic, weak) THLFacebookPictureWireframe *facebookPictureWireframe;
@property (nonatomic, weak) THLNumberVerificationWireframe *numberVerificationWireframe;
@property (nonatomic, weak) THLGuestFlowWireframe *guestFlowWireframe;
@property (nonatomic, weak) THLHostFlowWireframe *hostFlowWireframe;
@property (nonatomic, weak) THLMessageListWireframe *messageListWireframe;
@property (nonatomic, weak) THLEventDiscoveryWireframe *eventDiscoveryWireframe;
@property (nonatomic, weak) THLDashboardWireframe *dashboardWireframe;
@property (nonatomic, weak) THLHostDashboardWireframe *hostDashboardWireframe;
@property (nonatomic, weak) THLUserProfileWireframe *userProfileWireframe;
@property (nonatomic, weak) THLEventDetailWireframe *eventDetailWireframe;
@property (nonatomic, weak) THLEventHostingWireframe *eventHostingWireframe;
@property (nonatomic, weak) THLGuestlistInvitationWireframe *guestlistInvitationWireframe;
@property (nonatomic, weak) THLGuestlistReviewWireframe *guestlistReviewWireframe;
@property (nonatomic, weak) THLPopupNotificationWireframe *popupNotificationWireframe;
@property (nonatomic, weak) THLPerkStoreWireframe *perkStoreWireframe;
@property (nonatomic, weak) THLPerkDetailWireframe *perkDetailWireframe;
@property (nonatomic, weak) THLWaitlistPresenter *waitlistPresenter;

//Common
@property (nonatomic, strong) THLYapDatabaseManager *databaseManager;
@property (nonatomic, strong) THLUserManager *userManager;
@property (nonatomic, strong) THLEntityMapper *entityMapper;
@property (nonatomic, strong) THLViewDataSourceFactory *viewDataSourceFactory;
@property (nonatomic, strong) THLYapDatabaseViewFactory *yapDatabaseViewFactory;
@property (nonatomic, strong) THLParseQueryFactory *parseQueryFactory;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) APAddressBook *addressBook;

//Data Stores
@property (nonatomic, strong) THLDataStore *userDataStore;
@property (nonatomic, strong) THLDataStore *eventDataStore;
@property (nonatomic, strong) THLDataStore *guestDataStore;
@property (nonatomic, strong) THLDataStore *guestlistDataStore;
@property (nonatomic, strong) THLDataStore *guestlistInviteDataStore;
@property (nonatomic, strong) THLDataStore *perkStoreItemDataStore;

//Services
@property (nonatomic, strong) THLEventService *eventService;
@property (nonatomic, strong) THLFacebookProfilePictureURLFetchService *facebookProfilePictureURLFetchService;
@property (nonatomic, strong) THLLoginService *loginService;
@property (nonatomic, strong) THLLocationService *locationService;
@property (nonatomic, strong) THLGuestlistService *guestlistService;
@property (nonatomic, strong) THLPerkStoreItemService *perkStoreItemService;

@end

@implementation THLDependencyManager
#pragma mark - Construction
- (THLLoginWireframe *)newLoginWireframe {
	THLLoginWireframe *wireframe = [[THLLoginWireframe alloc] initWithLoginService:self.loginService
																	   userManager:self.userManager
														  numberVerificationModule:[self newNumberVerificationWireframe].moduleInterface
															 facebookPictureModule:[self newFacebookPictureWireframe].moduleInterface];
	self.loginWireframe = wireframe;
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

- (THLMessageListWireframe *)newMessageListWireframe {
    THLMessageListWireframe *wireframe = [[THLMessageListWireframe alloc] initWithDataStore:self.eventDataStore
                                                                                     entityMapper:self.entityMapper
                                                                                     eventService:self.eventService
                                                                            viewDataSourceFactory:self.viewDataSourceFactory];
    self.messageListWireframe = wireframe;
    return wireframe;
}

- (THLEventDiscoveryWireframe *)newEventDiscoveryWireframe {
	THLEventDiscoveryWireframe *wireframe = [[THLEventDiscoveryWireframe alloc] initWithDataStore:self.eventDataStore
																					 entityMapper:self.entityMapper
																					 eventService:self.eventService
																			viewDataSourceFactory:self.viewDataSourceFactory];
	self.eventDiscoveryWireframe = wireframe;
	return wireframe;
}

- (THLDashboardWireframe *)newDashboardWireframe {
    THLDashboardWireframe *wireframe = [[THLDashboardWireframe alloc] initWithGuestlistService:self.guestlistService
                                                                            entityMappper:self.entityMapper
                                                                         viewDataSourceFactory:self.viewDataSourceFactory
                                                                                     dataStore:self.guestlistInviteDataStore];

    self.dashboardWireframe = wireframe;
    return wireframe;
}

- (THLHostDashboardWireframe *)newHostDashboardWireframe {
    THLHostDashboardWireframe *wireframe = [[THLHostDashboardWireframe alloc] initWithGuestlistService:self.guestlistService
                                                                                 entityMappper:self.entityMapper
                                                                         viewDataSourceFactory:self.viewDataSourceFactory
                                                                                     dataStore:self.guestlistDataStore];
    
    self.hostDashboardWireframe = wireframe;
    return wireframe;
}

- (THLUserProfileWireframe *)newUserProfileWireframe {
    THLUserProfileWireframe *wireframe = [[THLUserProfileWireframe alloc] init];
    self.userProfileWireframe = wireframe;
    return wireframe;
}

- (THLEventDetailWireframe *)newEventDetailWireframe {
	THLEventDetailWireframe *wireframe = [[THLEventDetailWireframe alloc] initWithLocationService:self.locationService
                                                                                 guestlistService:self.guestlistService
																					entityMappper:self.entityMapper
                                                                                  databaseManager:self.databaseManager];
	self.eventDetailWireframe = wireframe;
	return wireframe;
}

- (THLEventHostingWireframe *)newEventHostingWireframe {
    THLEventHostingWireframe *wireframe = [[THLEventHostingWireframe alloc] initWithDataStore:self.guestlistDataStore
                                                                             guestlistService:self.guestlistService
                                                                        viewDataSourceFactory:self.viewDataSourceFactory
                                                                                entityMappper:self.entityMapper];
    self.eventHostingWireframe = wireframe;
    return wireframe;
}

- (THLGuestlistInvitationWireframe *)newGuestlistInvitationWireframe {
	THLGuestlistInvitationWireframe *wireframe = [[THLGuestlistInvitationWireframe alloc] initWithGuestlistService:self.guestlistService
                                                                                                      entityMapper:self.entityMapper
																							 viewDataSourceFactory:self.viewDataSourceFactory
																									   addressBook:self.addressBook
																										 dataStore:self.guestDataStore
                                                                                                        dataStore2:self.guestlistInviteDataStore];
	self.guestlistInvitationWireframe = wireframe;
	return wireframe;
}

- (THLGuestlistReviewWireframe *)newGuestlistReviewWireframe {
    THLGuestlistReviewWireframe *wireframe = [[THLGuestlistReviewWireframe alloc] initWithGuestlistService:self.guestlistService
                                                                                                      entityMapper:self.entityMapper
                                                                                                 dataStore:self.guestlistInviteDataStore
                                                                                             viewDataSourceFactory:self.viewDataSourceFactory];
    self.guestlistReviewWireframe = wireframe;
    return wireframe;
}

- (THLGuestFlowWireframe *)newGuestFlowWireframe {
	THLGuestFlowWireframe *wireframe = [[THLGuestFlowWireframe alloc] initWithDependencyManager:self];
	self.guestFlowWireframe = wireframe;
	return wireframe;
}

- (THLHostFlowWireframe *)newHostFlowWireframe {
    THLHostFlowWireframe *wireframe = [[THLHostFlowWireframe alloc] initWithDependencyManager:self];
    self.hostFlowWireframe = wireframe;
    return wireframe;
}

- (THLPopupNotificationWireframe *)newPopupNotificationWireframe {
    THLPopupNotificationWireframe *wireframe = [[THLPopupNotificationWireframe alloc] initWithGuestlistService:self.guestlistService
                                                                                                  entityMapper:self.entityMapper
                                                                                                     dataStore:self.guestlistInviteDataStore];
    self.popupNotificationWireframe = wireframe;
    return wireframe;
}

- (THLPerkStoreWireframe *)newPerkStoreWireframe {
    THLPerkStoreWireframe *wireframe = [[THLPerkStoreWireframe alloc] initWithDataStore:self.perkStoreItemDataStore
                                                                           entityMapper:self.entityMapper perkStoreItemService:self.perkStoreItemService viewDataSourceFactory:self.viewDataSourceFactory];
    self.perkStoreWireframe = wireframe;
    return wireframe;
}

- (THLPerkDetailWireframe *)newPerkDetailWireframe {
    THLPerkDetailWireframe *wireframe = [[THLPerkDetailWireframe alloc] initWithPerkStoreItemService:self.perkStoreItemService entityMapper:self.entityMapper];
    self.perkDetailWireframe = wireframe;
    return wireframe;
}

- (THLWaitlistPresenter *)newWaitlistPresenter {
	THLWaitlistPresenter *presenter = [[THLWaitlistPresenter alloc] init];
	self.waitlistPresenter = presenter;
	return presenter;
}

#pragma mark - Lazy Instantiation
#pragma mark - Wireframes
- (THLMasterWireframe *)masterWireframe {
	if (!_masterWireframe) {
		_masterWireframe = [[THLMasterWireframe alloc] initWithDependencyManager:self];
	}
	return _masterWireframe;
}

#pragma mark - Common
- (THLYapDatabaseManager *)databaseManager {
	if (!_databaseManager) {
		_databaseManager = [[THLYapDatabaseManager alloc] init];
	}
	return _databaseManager;
}

- (THLUserManager *)userManager {
	if (!_userManager) {
		_userManager = [[THLUserManager alloc] init];
	}
	return _userManager;
}

- (THLEntityMapper *)entityMapper {
	if (!_entityMapper) {
		_entityMapper = [[THLEntityMapper alloc] init];
	}
	return _entityMapper;
}

- (THLViewDataSourceFactory *)viewDataSourceFactory {
	if (!_viewDataSourceFactory) {
		_viewDataSourceFactory = [[THLViewDataSourceFactory alloc] initWithViewFactory:self.yapDatabaseViewFactory
																	   databaseManager:self.databaseManager];
	}
	return _viewDataSourceFactory;
}

- (THLYapDatabaseViewFactory *)yapDatabaseViewFactory {
	if (!_yapDatabaseViewFactory) {
		_yapDatabaseViewFactory = [[THLYapDatabaseViewFactory alloc] initWithDatabaseManager:self.databaseManager];
	}
	return _yapDatabaseViewFactory;
}

- (THLParseQueryFactory *)parseQueryFactory {
	if (!_parseQueryFactory) {
		_parseQueryFactory = [[THLParseQueryFactory alloc] init];
	}
	return _parseQueryFactory;
}

- (CLGeocoder *)geocoder {
	if (!_geocoder) {
		_geocoder = [[CLGeocoder alloc] init];
	}
	return _geocoder;
}

- (APAddressBook *)addressBook {
	if (!_addressBook) {
		_addressBook = [[APAddressBook alloc] init];
	}
	return _addressBook;
}

#pragma mark - Data Stores
- (THLDataStore *)userDataStore {
    if (!_userDataStore) {
        _userDataStore = [[THLDataStore alloc] initForKey:@"kUserDataStoreKey" databaseManager:self.databaseManager];
    }
    return _userDataStore;
}

- (THLDataStore *)eventDataStore {
	if (!_eventDataStore) {
		_eventDataStore = [[THLDataStore alloc] initForEntity:[THLEventEntity class] databaseManager:self.databaseManager];
	}
	return _eventDataStore;
}

- (THLDataStore *)guestDataStore {
	if (!_guestDataStore) {
		_guestDataStore = [[THLDataStore alloc] initForEntity:[THLGuestEntity class] databaseManager:self.databaseManager];
	}
	return _guestDataStore;
}

- (THLDataStore *)guestlistDataStore {
    if (!_guestlistDataStore) {
        _guestlistDataStore = [[THLDataStore alloc] initForEntity:[THLGuestlistEntity class] databaseManager:self.databaseManager];
    }
    return _guestlistDataStore;
}

- (THLDataStore *)guestlistInviteDataStore {
    if (!_guestlistInviteDataStore) {
        _guestlistInviteDataStore = [[THLDataStore alloc] initForEntity:[THLGuestlistInviteEntity class] databaseManager:self.databaseManager];
    }
    return _guestlistInviteDataStore;
}

- (THLDataStore *)perkStoreItemDataStore {
    if (!_perkStoreItemDataStore) {
        _perkStoreItemDataStore = [[THLDataStore alloc] initForEntity:[THLPerkStoreItemEntity class] databaseManager:self.databaseManager];
    }
    return _perkStoreItemDataStore;
}

#pragma mark - Services
- (THLEventService *)eventService {
	if (!_eventService) {
		_eventService = [[THLEventService alloc] initWithQueryFactory:self.parseQueryFactory];
	}
	return _eventService;
}

- (THLFacebookProfilePictureURLFetchService *)facebookProfilePictureURLFetchService {
	if (!_facebookProfilePictureURLFetchService) {
		_facebookProfilePictureURLFetchService = [[THLFacebookProfilePictureURLFetchService alloc] init];
	}
	return _facebookProfilePictureURLFetchService;
}

- (THLLoginService *)loginService {
	if (!_loginService) {
		_loginService = [[THLLoginService alloc] init];
	}
	return _loginService;
}

- (THLLocationService *)locationService {
	if (!_locationService) {
		_locationService = [[THLLocationService alloc] initWithGeocoder:self.geocoder];
	}
	return _locationService;
}

- (THLGuestlistService *)guestlistService {
	if (!_guestlistService) {
		_guestlistService = [[THLGuestlistService alloc] initWithQueryFactory:self.parseQueryFactory];
	}
	return _guestlistService;
}

- (THLPerkStoreItemService *)perkStoreItemService {
    if (!_perkStoreItemService) {
        _perkStoreItemService = [[THLPerkStoreItemService alloc] initWithQueryFactory:self.parseQueryFactory];
    }
    return _perkStoreItemService;
}
@end
