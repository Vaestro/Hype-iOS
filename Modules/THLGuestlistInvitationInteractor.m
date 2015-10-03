//
//  THLGuestlistInvitationInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistInvitationInteractor.h"
@interface THLGuestlistInvitationInteractor ()
@property (nonatomic, strong) NSArray *currentGuests;
@property (nonatomic, strong) NSMutableArray *addedGuests;
@property (nonatomic, strong) NSMutableArray *removedGuests;
@end

@implementation THLGuestlistInvitationInteractor
- (instancetype)init {
	if (self = [super init]) {
		_addedGuests = [NSMutableArray new];
		_removedGuests = [NSMutableArray new];
	}
	return self;
}

- (instancetype)initWithDataManager:(THLGuestlistInvitationDataManager *)dataManager {
	if (self = [self init]) {
		_dataManager = dataManager;
	}
	return self;
}

- (void)setGuestlistId:(NSString *)guestlistId {
	_guestlistId = [guestlistId copy];
	_currentGuests = nil;
	[_addedGuests removeAllObjects];
	[_removedGuests removeAllObjects];
}

- (void)checkForGuestlist {
	NSAssert(_guestlistId != nil, @"_guestlistId must be set prior to this call!");
}

- (void)getInvitableUsers {
	[self checkForGuestlist];
	[_delegate interactor:self didGetInvitableUsers:nil error:nil];
}


- (BOOL)isGuestInvited:(THLUserEntity *)guest {
	[self checkForGuestlist];
	return (![_removedGuests containsObject:guest] &&
			([_currentGuests containsObject:guest] || [_addedGuests containsObject:guest]));
}

- (BOOL)canAddGuest:(THLUserEntity *)guest {
	[self checkForGuestlist];
	return ![self isGuestInvited:guest];
}

- (BOOL)canRemoveGuest:(THLUserEntity *)guest {
	[self checkForGuestlist];
	return [_addedGuests containsObject:guest];
}

- (void)addGuest:(THLUserEntity *)guest {
	[self checkForGuestlist];
	if ([self canAddGuest:guest]) {
		[_addedGuests addObject:guest];
		[_removedGuests removeObject:guest];
	}
}

- (void)removeGuest:(THLUserEntity *)guest {
	[self checkForGuestlist];
	if ([self canRemoveGuest:guest]) {
		[_removedGuests addObject:guest];
		[_addedGuests removeObject:guest];
	}
}

- (void)commitChangesToGuestlist {
	[self checkForGuestlist];
	[_delegate interactor:self didCommitChangesToGuestlist:_guestlistId error:nil];
}

@end
