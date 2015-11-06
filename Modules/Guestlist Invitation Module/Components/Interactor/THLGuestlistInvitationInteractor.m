//
//  THLGuestlistInvitationInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInvitationInteractor.h"
#import "THLGuestlistInvitationDataManager.h"
#import "THLViewDataSourceFactoryInterface.h"
#import "THLGuestEntity.h"
#import "THLGuestlistEntity.h"
#import "THLGuestlistInvite.h"
#import "THLPromotionEntity.h"

static NSString *const kGuestEntityFirstNameKey = @"firstName";
static NSString *const kGuestEntityLastNameKey = @"lastName";
static NSString *const kGuestEntityPhoneNumberKey = @"phoneNumber";
static NSString *const kGuestEntityObjectIdKey = @"objectId";
static NSString *const kTHLGuestlistInvitationSearchViewKey = @"kTHLGuestlistInvitationSearchViewKey";
@class THLGuestlistInviteEntity;

@interface THLGuestlistInvitationInteractor ()
@property (nonatomic, copy) NSString *guestlistId;
@property (nonatomic, strong) NSArray *currentGuests;
@property (nonatomic, strong) NSMutableArray *addedGuests;
@property (nonatomic, strong) NSMutableArray *addedGuestDigits;
@end

@implementation THLGuestlistInvitationInteractor
- (instancetype)initWithDataManager:(THLGuestlistInvitationDataManager *)dataManager
			  viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
	if (self = [super init]) {
		_dataManager = dataManager;
		_viewDataSourceFactory = viewDataSourceFactory;
		_addedGuests = [NSMutableArray new];
	}
	return self;
}

- (void)setPromotionEntity:(THLPromotionEntity *)promotionEntity {
    _promotionEntity = promotionEntity;
    [_addedGuestDigits removeAllObjects];
    _currentGuests = nil;
}

- (void)loadGuestlist:(NSString *)guestlistId withCurrentGuests:(NSArray<THLGuestEntity *> *)currentGuests {
	_guestlistId = [guestlistId copy];
	_currentGuests = currentGuests;
}

- (void)checkForGuestlist {
	NSAssert(_guestlistId != nil, @"_guestlistId must be set prior to this call!");
}

- (THLSearchViewDataSource *)getDataSource {
	[self loadGuestContacts];
	THLViewDataSourceGrouping *grouping = [self viewGrouping];
	THLViewDataSourceSorting *sorting = [self viewSorting];
	THLSearchResultsViewDataSourceHandler *handler = [self viewHandler];
	THLSearchViewDataSource *searchDataSource = [_viewDataSourceFactory createSearchDataSourceWithGrouping:grouping sorting:sorting handler:handler searchableProperties:@[kGuestEntityFirstNameKey, kGuestEntityLastNameKey, kGuestEntityObjectIdKey, kGuestEntityPhoneNumberKey] key:kTHLGuestlistInvitationSearchViewKey];
	return searchDataSource;
}

- (THLViewDataSourceGrouping *)viewGrouping {
	return [THLViewDataSourceGrouping withEntityBlock:^NSString *(NSString *collection, THLEntity *entity) {
		if ([entity isKindOfClass:[THLGuestEntity class]]) {
			THLGuestEntity *guest = (THLGuestEntity *)entity;
			if (guest.firstName) {
				return [guest.firstName substringToIndex:1];
			} else if (guest.lastName) {
				return [guest.lastName substringToIndex:1];
			} else {
				return @"123?";
			}
		}
		return nil;
	}];
}

- (THLViewDataSourceSorting *)viewSorting {
	return [THLViewDataSourceSorting withSortingBlock:^NSComparisonResult(THLEntity *entity1, THLEntity *entity2) {
		THLGuestEntity *guest1 = (THLGuestEntity *)entity1;
		THLGuestEntity *guest2 = (THLGuestEntity *)entity2;
		return [guest1.fullName compare:guest2.fullName];
	}];
}

- (THLSearchResultsViewDataSourceHandler *)viewHandler {
	return [THLSearchResultsViewDataSourceHandler withBlock:^(NSMutableDictionary *dict, NSString *collection, id object) {
		if ([object isKindOfClass:[THLGuestEntity class]]) {
			THLGuestEntity *guest = (THLGuestEntity *)object;
			dict[kGuestEntityFirstNameKey] = guest.firstName;
			dict[kGuestEntityLastNameKey] = guest.lastName;
			dict[kGuestEntityPhoneNumberKey] = guest.phoneNumber;
			dict[kGuestEntityObjectIdKey] = guest.objectId;
		}
	}];
}

- (void)loadGuestContacts {
	[_dataManager loadContacts];
}

- (BOOL)isGuestInvited:(THLGuestEntity *)guest {
//	[self checkForGuestlist];
	return [_currentGuests containsObject:guest] || [_addedGuests containsObject:guest];
}

- (BOOL)canAddGuest:(THLGuestEntity *)guest {
//	[self checkForGuestlist];
	return ![self isGuestInvited:guest];
}

- (BOOL)canRemoveGuest:(THLGuestEntity *)guest {
//	[self checkForGuestlist];
	return [_addedGuests containsObject:guest];
}

- (void)addGuest:(THLGuestEntity *)guest {
//	[self checkForGuestlist];
	if ([self canAddGuest:guest]) {
		[_addedGuests addObject:guest];
    }
}

- (void)removeGuest:(THLGuestEntity *)guest {
//	[self checkForGuestlist];
	if ([self canRemoveGuest:guest]) {
		[_addedGuests removeObject:guest];
    }
}


- (NSArray *)obtainDigits:(NSArray<THLGuestEntity *> *)addedGuests {
    return [addedGuests linq_select:^id(id guest) {
        return [guest intPhoneNumberFormat];
    }];
}

- (void)commitChangesToGuestlist {
    WEAKSELF();
//	[self checkForGuestlist];
    if (_guestlistId == nil) {
        [[_dataManager submitGuestlistForPromotion:_promotionEntity.objectId withInvites:[self obtainDigits:_addedGuests]] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            [_delegate interactor:WSELF didCommitChangesToGuestlist:task.error];
            return nil;
        }];
    } else if (_guestlistId != nil) {
        [[_dataManager updateGuestlist:_guestlistId withInvites:[self obtainDigits:_addedGuests]] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            [_delegate interactor:WSELF didCommitChangesToGuestlist:task.error];
            return nil;
        }];
    }
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end