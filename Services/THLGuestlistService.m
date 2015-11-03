//
//  THLGuestlistService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistService.h"
#import "THLParseQueryFactory.h"
#import "Parse.h"

@implementation THLGuestlistService

- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory {
	if (self = [super init]) {
		_queryFactory = queryFactory;
	}
	return self;
}

- (BFTask *)fetchInvitesOnGuestlist:(THLGuestlist *)guestlist {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    NSMutableArray *completedGuestlistInvites = [NSMutableArray new];
    [[_queryFactory queryForInvitesOnGuestlist:guestlist] findObjectsInBackgroundWithBlock:^(NSArray *guestlistInvites, NSError *error) {
        // GuestlistInvites now contains the Guestlist Invites on the Guestlist, and the "Guest" field
        // has been populated. For example:
        for (PFObject *guestlistInvite in guestlistInvites) {
            // This does not require a network access.
            PFObject *guest = guestlistInvite[@"Guest"];
//            PFObject *parentGuestlist = guestlistInvite[@"Guestlist"];
//            PFObject *parentGuestlistOwner = guestlistInvite[@"Guestlist"][@"Owner"];
//            [parentGuestlist setObject:parentGuestlistOwner forKey:@"owner"];
            [guestlistInvite setObject:guest forKey:@"guest"];
//            [guestlistInvite setObject:parentGuestlist forKey:@"guestlist"];
            [completedGuestlistInvites addObject:guestlistInvite];
        }
        [completionSource setResult:completedGuestlistInvites];
    }];
    return completionSource.task;

}

- (BFTask *)fetchGuestlistForGuest:(THLUser *)guest forEvent:(NSString *)eventId {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    NSMutableArray *completedGuestlists = [NSMutableArray new];
    [[_queryFactory queryForGuestlistForGuest:guest forEvent:eventId] findObjectsInBackgroundWithBlock:^(NSArray *guestlists, NSError *error) {
        for (PFObject *guestlist in guestlists) {
            PFObject *owner = guestlist[@"Owner"];
            [guestlist setObject:owner forKey:@"owner"];
            [completedGuestlists addObject:guestlist];
        }
        [completionSource setResult:completedGuestlists];
    }];
    return completionSource.task;
}

- (BFTask *)createGuestlistForPromotion:(NSString *)promotionId withInvites:(NSArray *)guestPhoneNumbers {
    return [PFCloud callFunctionInBackground:@"createGuestlist"
                       withParameters:@{@"promotionId": promotionId, @"guestDigits": guestPhoneNumbers}];
}

@end
