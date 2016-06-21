//
//  THLDependencyManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/24/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLDependencyManager.h"
#import "THLMasterWireframe.h"

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
#import "THLMessageListEntity.h"


@interface THLDependencyManager()
@property (nonatomic, strong) THLMasterWireframe *masterWireframe;


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
@property (nonatomic, strong) THLDataStore *messageListDataStore;
@property (nonatomic, strong) THLDataStore *contactsDataStore;

//Services
@property (nonatomic, strong) THLEventService *eventService;
@property (nonatomic, strong) THLFacebookProfilePictureURLFetchService *facebookProfilePictureURLFetchService;
@property (nonatomic, strong) THLLoginService *loginService;
@property (nonatomic, strong) THLLocationService *locationService;
@property (nonatomic, strong) THLGuestlistService *guestlistService;
@property (nonatomic, strong) THLPerkStoreItemService *perkStoreItemService;


@end

@implementation THLDependencyManager


#pragma mark - Lazy Instantiation
#pragma mark - Wireframes
- (THLMasterWireframe *)masterWireframe
{
	if (!_masterWireframe) {
		_masterWireframe = [[THLMasterWireframe alloc] initWithDependencyManager:self];
	}
	return _masterWireframe;
}

#pragma mark - Common
- (THLYapDatabaseManager *)databaseManager
{
	if (!_databaseManager) {
		_databaseManager = [[THLYapDatabaseManager alloc] init];
	}
	return _databaseManager;
}

- (THLUserManager *)userManager
{
	if (!_userManager) {
		_userManager = [[THLUserManager alloc] init];
	}
	return _userManager;
}

- (THLEntityMapper *)entityMapper
{
	if (!_entityMapper) {
		_entityMapper = [[THLEntityMapper alloc] init];
	}
	return _entityMapper;
}

- (THLViewDataSourceFactory *)viewDataSourceFactory
{
	if (!_viewDataSourceFactory) {
		_viewDataSourceFactory = [[THLViewDataSourceFactory alloc] initWithViewFactory:self.yapDatabaseViewFactory
																	   databaseManager:self.databaseManager];
	}
	return _viewDataSourceFactory;
}

- (THLYapDatabaseViewFactory *)yapDatabaseViewFactory
{
	if (!_yapDatabaseViewFactory) {
		_yapDatabaseViewFactory = [[THLYapDatabaseViewFactory alloc] initWithDatabaseManager:self.databaseManager];
	}
	return _yapDatabaseViewFactory;
}

- (THLParseQueryFactory *)parseQueryFactory
{
	if (!_parseQueryFactory) {
		_parseQueryFactory = [[THLParseQueryFactory alloc] init];
	}
	return _parseQueryFactory;
}

- (CLGeocoder *)geocoder
{
	if (!_geocoder) {
		_geocoder = [[CLGeocoder alloc] init];
	}
	return _geocoder;
}

- (APAddressBook *)addressBook
{
	if (!_addressBook) {
		_addressBook = [[APAddressBook alloc] init];
	}
	return _addressBook;
}

#pragma mark - Data Stores
- (THLDataStore *)contactsDataStore
{
    if (!_contactsDataStore) {
        _contactsDataStore = [[THLDataStore alloc] initForEntity:[THLGuestEntity class] databaseManager:self.databaseManager];
    }
    return _contactsDataStore;
}


#pragma mark - Services
- (THLEventService *)eventService
{
	if (!_eventService) {
		_eventService = [[THLEventService alloc] initWithQueryFactory:self.parseQueryFactory];
	}
	return _eventService;
}

- (THLFacebookProfilePictureURLFetchService *)facebookProfilePictureURLFetchService
{
	if (!_facebookProfilePictureURLFetchService) {
		_facebookProfilePictureURLFetchService = [[THLFacebookProfilePictureURLFetchService alloc] init];
	}
	return _facebookProfilePictureURLFetchService;
}

- (THLLoginService *)loginService
{
	if (!_loginService) {
		_loginService = [[THLLoginService alloc] init];
	}
	return _loginService;
}

- (THLLocationService *)locationService
{
	if (!_locationService) {
		_locationService = [[THLLocationService alloc] initWithGeocoder:self.geocoder];
	}
	return _locationService;
}

- (THLGuestlistService *)guestlistService
{
	if (!_guestlistService) {
		_guestlistService = [[THLGuestlistService alloc] initWithQueryFactory:self.parseQueryFactory];
	}
	return _guestlistService;
}

- (THLPerkStoreItemService *)perkStoreItemService
{
    if (!_perkStoreItemService) {
        _perkStoreItemService = [[THLPerkStoreItemService alloc] initWithQueryFactory:self.parseQueryFactory];
    }
    return _perkStoreItemService;
}

@end
