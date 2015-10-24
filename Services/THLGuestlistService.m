//
//  THLGuestlistService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistService.h"
#import "THLParseQueryFactory.h"

@implementation THLGuestlistService
- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory {
	if (self = [super init]) {
		_queryFactory = queryFactory;
	}
	return self;
}

- (BFTask *)fetchGuestlistForGuest:(THLUser *)guest forEvent:(NSString *)eventId {
    return [[_queryFactory queryForGuestlistForGuest:guest forEvent:eventId] findObjectsInBackground];
}

//- (BFTask *)createGuestlistForPromotion:(THLPromotion *)promotion forOwner:(THLUser *)owner {
//    PFObject *guestlist = [PFObject objectWithClassName:@"Guestlist"];
//    guestlist[@"owner"] = owner;
//    guestlist[@"promotion"] = promotion;
//    [guestlist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            return TRUE;
//        } else {
//            return error;
//        }
//    }];
//}

@end
