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
#import "THLPromotionServiceInterface.h"
#import "THLGuestlist.h"
#import "THLGuestlistEntity.h"
#import "THLEntityMapper.h"
#import "THLDataStoreDomain.h"
#import "THLPromotionEntity.h"

@implementation THLGuestlistInvitationDataManager
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
							   dataStore:(THLDataStore *)dataStore
							 addressBook:(APAddressBook *)addressBook
                guestlistInviteDataStore:(THLDataStore *)guestlistInviteDataStore {
	if (self = [super init]) {
		_guestlistService = guestlistService;
        _entityMapper = entityMapper;
		_dataStore = dataStore;
		_addressBook = addressBook;
        _guestlistInviteDataStore = guestlistInviteDataStore;
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

- (BFTask *)submitGuestlistForPromotion:(THLPromotionEntity *)promotionEntity withInvites:(NSArray *)guestPhoneNumbers {
    return [[_guestlistService createGuestlistForPromotion:promotionEntity withInvites:guestPhoneNumbers] continueWithSuccessBlock:^id(BFTask *task) {
        return [BFTask taskWithResult:nil];
    }];
}

- (BFTask *)getOwnerInviteForPromotion:(THLPromotionEntity *)promotionEntity {
    WEAKSELF();
    return [[_guestlistService fetchGuestlistInviteForEvent:promotionEntity.event] continueWithSuccessBlock:^id(BFTask *task) {
        THLGuestlistInviteEntity *guestlistInviteEntity = [WSELF.entityMapper mapGuestlistInvite:task.result];
        [WSELF.guestlistInviteDataStore updateOrAddEntities:[NSSet setWithArray:@[guestlistInviteEntity]]];
        return [BFTask taskWithResult:nil];
    }];
}

- (BFTask *)updateGuestlist:(NSString *)guestlistId withInvites:(NSArray *)guestPhoneNumbers forPromotion:(THLPromotionEntity *)promotionEntity {
    return [[_guestlistService updateGuestlist:guestlistId withInvites:guestPhoneNumbers forPromotion:promotionEntity] continueWithSuccessBlock:^id(BFTask *task) {
        //        NSArray<THLGuestlistEntity *> *guestlist = [_entityMapper mapGuestlists:@[task.result]];
        return [BFTask taskWithResult:nil];
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
		return ((contact.name.firstName != NULL || contact.name.lastName != NULL) && contact.phones.count > 0);
	};
    
    _addressBook.fieldsMask = APContactFieldDefault;
    
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

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
