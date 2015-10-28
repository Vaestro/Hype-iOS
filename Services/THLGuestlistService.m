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

- (BFTask *)fetchGuestlistForGuest:(NSString *)guestId forEvent:(NSString *)eventId {
    return [[_queryFactory queryForGuestlistForGuest:guestId forEvent:eventId] findObjectsInBackground];
}

- (BFTask *)createGuestlistForPromotion:(NSString *)promotionId withInvites:(NSArray *)guestPhoneNumbers {
    return [PFCloud callFunctionInBackground:@"createGuestlist"
                       withParameters:@{@"promotionId": promotionId, @"guestDigits": guestPhoneNumbers}];
}

@end
