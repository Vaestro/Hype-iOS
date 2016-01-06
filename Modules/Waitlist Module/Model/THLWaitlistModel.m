//
//  THLWaitlistModel.m
//  Hype
//
//  Created by Phil Meyers IV on 12/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLWaitlistModel.h"
#import "THLWaitlistEntry.h"
#import "Bolts.h"
#import "THLGuestlistInvite.h"
#import "PFInstallation.h"

static NSString *const kTHLWaitlistModelPinName = @"kTHLWaitlistModelPinName";

@interface THLWaitlistModel()
@property (nonatomic, strong) THLWaitlistEntry *entry;
@end

@implementation THLWaitlistModel
- (instancetype)init {
	if (self = [super init]) {

	}
	return self;
}

- (void)setEntry:(THLWaitlistEntry *)entry {
	_entry = entry;
	[entry pinWithName:kTHLWaitlistModelPinName];
}

- (void)checkForExisitngLocalWaitlistEntry {
	[[[self localEntryQuery] getFirstObjectInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull task) {
		if (task.result) {
			THLWaitlistEntry *existingEntry = (THLWaitlistEntry *)task.result;
			self.entry = existingEntry;
		}
        
        [_delegate model:self didCheckForExistingEntry:(task.result != nil) error:task.result];
		return nil;
	}];
}

- (void)checkForApprovedWaitlistEntry {
    [[self checkForExistingWaitlistEntryForEmail:self.entry.email] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull task) {
        if (task.result) {
            THLWaitlistEntry *existingEntry = (THLWaitlistEntry *)task.result;
            self.entry = existingEntry;
            [_delegate model:self didCheckForApprovedEntry:(existingEntry.approved == TRUE) error:task.result];
        }
        return nil;
    }];
}

- (PFQuery *)localEntryQuery {
	PFQuery *query = [THLWaitlistEntry query];
	[query fromPinWithName:kTHLWaitlistModelPinName];
	return query;
}

- (void)createWaitlistEntryForEmail:(NSString *)email {
	[[[self checkForExistingWaitlistEntryForEmail:email] continueWithBlock:^id _Nullable(BFTask * _Nonnull task) {
		if (task.result) {
			THLWaitlistEntry *existingEntry = (THLWaitlistEntry *)task.result;
			self.entry = existingEntry;
			return [BFTask taskWithResult:existingEntry];
		} else {
			THLWaitlistEntry *newEntry = [THLWaitlistEntry object];
			newEntry.email = email;
            newEntry.approved = FALSE;
            newEntry.deviceToken = [PFInstallation currentInstallation].deviceToken;
			self.entry = newEntry;
			return [newEntry saveInBackground];
		}
	}] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull task) {
		if (task.error) {
			self.entry = nil;
		}

		[_delegate modelDidCreateEntry:self error:task.error];
		return nil;
	}];
}

- (BFTask *)checkForExistingWaitlistEntryForEmail:(NSString *)email {
	return [[self queryForExistingEntryWithEmail:email] getFirstObjectInBackground];
}

- (PFQuery *)queryForExistingEntryWithEmail:(NSString *)email {
	PFQuery *query = [THLWaitlistEntry query];
	[query whereKey:@"email" equalTo:email];
	return query;
}

- (void)getWaitlistPosition {
	[[[self queryForPreceedingEntries] countObjectsInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask<NSNumber *> * _Nonnull task) {
		if (task.result) {
			NSInteger position = [task.result integerValue] + 1;
			[_delegate model:self didGetWaitlistPosition:position error:nil];
		} else {
			[_delegate model:self didGetWaitlistPosition:-1 error:task.error];
		}
		return nil;
	}];
}

- (PFQuery *)queryForPreceedingEntries {
	NSAssert(self.entry != nil, @"There must be an entry!");
	PFQuery *query = [THLWaitlistEntry query];
	[query whereKey:@"createdAt" lessThan:self.entry.createdAt];
	return query;
}

- (PFQuery *)queryForMatchingInvitationCode:(NSString *)code {
    PFQuery *query = [THLGuestlistInvite query];
    [query whereKey:@"invitationCode" equalTo:code];
    return query;
}

- (BFTask *)getMatchingInvitationCode:(NSString *)code {
    return [[self queryForMatchingInvitationCode:code] getFirstObjectInBackground];
}

- (void)isValidCode:(NSString *)code {
//	NSAssert(self.entry != nil, @"There must be an entry!");
    [[self getMatchingInvitationCode:code] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id _Nullable(BFTask * _Nonnull task) {
        [_delegate model:self didGetMatchingCode:(task.result != nil) error:task.result];
        return nil;
    }];
}

@end
