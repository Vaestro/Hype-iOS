//
//  THLAddressBookPermissionsRequestService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/26/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLAddressBookPermissionsRequestService.h"
#import "APAddressBook.h"
#import "Bolts.h"

@implementation THLAddressBookPermissionsRequestService

- (BFTask *)requestPermissions {
	BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    APAddressBook *addressBook = [APAddressBook new];
	[addressBook requestAccess:^(BOOL granted, NSError *error) {
		if (granted) {
			[completionSource setResult:@(granted)];
		} else {
			[completionSource setError:error];
		}
	}];
	return completionSource.task;
}

@end
