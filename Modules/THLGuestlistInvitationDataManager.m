//
//  THLGuestlistInvitationDataManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInvitationDataManager.h"
#import "APAddressBook.h"
#import "APContact.h"
#import "THLGuestEntity.h"
#import "THLDataStore.h"
#import "THLGuestlistServiceInterface.h"
#import "THLGuestlist.h"

@implementation THLGuestlistInvitationDataManager
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
							   dataStore:(THLDataStore *)dataStore
							 addressBook:(APAddressBook *)addressBook {
	if (self = [super init]) {
		_guestlistService = guestlistService;
		_dataStore = dataStore;
		_addressBook = addressBook;
	}
	return self;
}

- (BFTask *)fetchMembersOnGuestlist:(NSString *)guestlistId {
	return [[_guestlistService fetchInvitesOnGuestlist:[THLGuestlist objectWithoutDataWithObjectId:guestlistId]] continueWithSuccessBlock:^id(BFTask *task) {
		NSArray<THLGuestEntity *> *guests = [self convertUsers:task.result];
		[self storeGuests:guests];
		return [BFTask taskWithResult:guests];
	}];
}

- (void)loadContacts {
	[[self getContactsTasks] continueWithSuccessBlock:^id(BFTask *task) {
		NSArray<THLGuestEntity *> *guestContacts = [self convertContacts:task.result];
		[self storeGuests:guestContacts];
		return nil;
	}];
}

- (BFTask *)getContactsTasks {
	return [[self getAddressBookAccessTask] continueWithSuccessBlock:^id(BFTask *task) {
		return [self loadContactsTask];
	}];
}

- (BFTask *)loadContactsTask {
	BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];

	_addressBook.filterBlock = ^BOOL(APContact *contact) {
		return contact.phones.count > 0;
	};

	[_addressBook loadContacts:^(NSArray *contacts, NSError *error) {
		if (error) {
			[completionSource setError:error];
		} else {
			[completionSource setResult:contacts];
		}
	}];

	return completionSource.task;
}

- (BFTask *)getAddressBookAccessTask {
	BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
	[[_addressBook class] requestAccess:^(BOOL granted, NSError *error) {
		if (error) {
			[completionSource setError:error];
		} else {
			[completionSource setResult:@(granted)];
		}
	}];
	return completionSource.task;
}

- (NSArray<THLGuestEntity *> *)convertContacts:(NSArray<APContact *> *)contacts {
	return [contacts linq_select:^id(id item) {
		APContact *contact = (APContact *)item;
		return [THLGuestEntity fromContact:contact];
	}];
}

- (NSArray<THLGuestEntity *> *)convertUsers:(NSArray<THLUserEntity *> *)users {
	return [users linq_select:^id(id item) {
		return [THLGuestEntity fromUser:(THLUserEntity *)item];
	}];
}

- (void)storeGuests:(NSArray<THLGuestEntity *> *)guests {
	[_dataStore updateOrAddEntities:[NSSet setWithArray:guests]];
}

@end
