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
#import "THLGuestlistInvite.h"
#import "THLPromotionEntity.h"
#import "THLEventEntity.h"
#import "THLPromotion.h"

@implementation THLGuestlistService

- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory {
	if (self = [super init]) {
		_queryFactory = queryFactory;
	}
	return self;
}

#pragma mark - Guestlist Services

- (BFTask *)fetchGuestlistsForPromotionAtEvent:(NSString *)eventId {
    return [[_queryFactory queryForGuestlistsForPromotionAtEvent:eventId] findObjectsInBackground];
}

- (BFTask *)createGuestlistForPromotion:(THLPromotionEntity *)promotionEntity withInvites:(NSArray *)guestPhoneNumbers {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    THLUser *currentUser = [THLUser currentUser];

    PFObject *guestlist = [PFObject objectWithClassName:@"Guestlist"];
    PFObject *guestlistInvite = [PFObject objectWithClassName:@"GuestlistInvite"];
    guestlist[@"Promotion"] = [THLPromotion objectWithoutDataWithObjectId:promotionEntity.objectId];
    guestlist[@"Owner"] = currentUser;
    guestlist[@"reviewStatus"] =  [NSNumber numberWithInt:0];
    guestlist[@"eventId"] = promotionEntity.eventId;
    [guestlist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [PFCloud callFunctionInBackground:@"sendOutNotifications"
                               withParameters:@{@"promotionId": promotionEntity.objectId,
                                                @"eventName":promotionEntity.event.location.name,
                                                @"promotionTime":promotionEntity.time,
                                                @"guestPhoneNumbers": guestPhoneNumbers,
                                                @"guestlistId": guestlist.objectId}
                                        block:^(id object, NSError *cloudError) {
                                            
                                            if (!cloudError){
                                                guestlistInvite[@"Guest"] = currentUser;
                                                guestlistInvite[@"Guestlist"] = guestlist;
                                                guestlistInvite[@"phoneNumber"] = currentUser.phoneNumber;
                                                guestlistInvite[@"response"] = [NSNumber numberWithInt:1];
                                                [guestlistInvite saveInBackground];
                                                
                                                [completionSource setResult:nil];
                                            }else {
                                                [completionSource setError:cloudError];
                                            }
                                        }];
        } else {
            [completionSource setError:error];
        }
    }];
    return completionSource.task;
}

- (BFTask *)updateGuestlist:(NSString *)guestlistId withInvites:(NSArray *)guestPhoneNumbers {
    [PFCloud callFunctionInBackground:@"updateGuestlist"
                              withParameters:@{@"guestlistId": guestlistId,
                                               @"guestDigits": guestPhoneNumbers}
                                block:^(id guestlistInvite, NSError *error) {
                                  PFObject *guestlist = guestlistInvite[@"Guestlist"];
                                  [guestlistInvite setObject:guestlist forKey:@"Guestlist"];
                                  PFObject *owner = guestlistInvite[@"Guestlist"][@"Owner"];
                                  [guestlist setObject:owner forKey:@"Owner"];
                                  PFObject *promotion = guestlistInvite[@"Guestlist"][@"Promotion"];
                                  [guestlist setObject:promotion forKey:@"Promotion"];
                                  PFObject *event = guestlistInvite[@"Guestlist"][@"Promotion"][@"event"];
                                  [promotion setObject:event forKey:@"event"];
                                  PFObject *location = guestlistInvite[@"Guestlist"][@"Promotion"][@"event"][@"location"];
                                  [event setObject:location forKey:@"location"];
                                  [guestlistInvite pinInBackgroundWithName:@"GuestlistInvites"];
                              }];
    return [BFTask taskWithResult:nil];
}

#pragma mark - Guestlist Invite Services

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
            if (guest != nil) {
                [guestlistInvite setObject:guest forKey:@"guest"];
            }
//            [guestlistInvite setObject:parentGuestlist forKey:@"guestlist"];
            [completedGuestlistInvites addObject:guestlistInvite];
        }
        [completionSource setResult:completedGuestlistInvites];
    }];
    return completionSource.task;

}

- (BFTask *)fetchGuestlistInviteForUser:(THLUser *)user atEvent:(NSString *)eventId {
    return [[_queryFactory queryForGuestlistInviteForUser:user atEvent:eventId] getFirstObjectInBackground];
}

- (BFTask *)fetchGuestlistInviteWithId:(NSString *)guestlistInviteId {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [[_queryFactory queryForGuestlistInviteWithId] getObjectInBackgroundWithId:guestlistInviteId block:^(PFObject *guestlistInvite, NSError *error) {
        if (!error) {
            PFObject *guestlist = guestlistInvite[@"Guestlist"];
            [guestlistInvite setObject:guestlist forKey:@"Guestlist"];
            PFObject *owner = guestlistInvite[@"Guestlist"][@"Owner"];
            [guestlist setObject:owner forKey:@"Owner"];
            PFObject *promotion = guestlistInvite[@"Guestlist"][@"Promotion"];
            [guestlist setObject:promotion forKey:@"Promotion"];
            PFObject *event = guestlistInvite[@"Guestlist"][@"Promotion"][@"event"];
            [promotion setObject:event forKey:@"event"];
            PFObject *location = guestlistInvite[@"Guestlist"][@"Promotion"][@"event"][@"location"];
            [event setObject:location forKey:@"location"];
            [guestlistInvite pinInBackgroundWithName:@"GuestlistInvites"];
            [completionSource setResult:guestlistInvite];
        } else {
            [completionSource setError:error];
        }
    }];
    return completionSource.task;
}

- (BFTask *)updateGuestlistInvite:(THLGuestlistInvite *)guestlistInvite withResponse:(THLStatus)response {
    NSNumber *castedResponse = [[NSNumber alloc] initWithInt:response];
    guestlistInvite[@"response"] = castedResponse;
    [guestlistInvite saveInBackground];
    return [BFTask taskWithResult:nil];
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
