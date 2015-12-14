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
#import "THLUser.h"

@implementation THLGuestlistService

- (instancetype)initWithQueryFactory:(THLParseQueryFactory *)queryFactory {
	if (self = [super init]) {
		_queryFactory = queryFactory;
	}
	return self;
}

#pragma mark - Guestlist Services

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists For Host at a Event/Promotion
//----------------------------------------------------------------

- (BFTask *)fetchGuestlistsForPromotionAtEvent:(NSString *)eventId {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    NSMutableArray *completedGuestlists = [NSMutableArray new];
    [[_queryFactory queryForGuestlistsForPromotionAtEvent:eventId] findObjectsInBackgroundWithBlock:^(NSArray *guestlists, NSError *error) {
        for (PFObject *guestlist in guestlists) {
            PFObject *promotion = guestlist[@"Promotion"];
            [guestlist setObject:promotion forKey:@"Promotion"];
            PFObject *host = guestlist[@"Promotion"][@"host"];
            if (host != nil) {
                [guestlist setObject:promotion forKey:@"host"];
            }
            [completedGuestlists addObject:guestlist];
        }
        [completionSource setResult:completedGuestlists];
    }];
    return completionSource.task;
}

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists For Host for Dashboard Notifications
//----------------------------------------------------------------

- (BFTask *)fetchGuestlistsRequestsForHost {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    NSMutableArray *completedGuestlists = [NSMutableArray new];
    [[_queryFactory queryForGuestlists] findObjectsInBackgroundWithBlock:^(NSArray *guestlists, NSError *error) {
        for (PFObject *guestlist in guestlists) {
            PFObject *promotion = guestlist[@"Promotion"];
            [guestlist setObject:promotion forKey:@"Promotion"];
            PFObject *host = guestlist[@"Promotion"][@"host"];
            if (host != nil) {
                [guestlist setObject:promotion forKey:@"host"];
            }
            [completedGuestlists addObject:guestlist];
        }
        [completionSource setResult:completedGuestlists];
    }];
    return completionSource.task;
}

//----------------------------------------------------------------
#pragma mark - Create Guestlist For Promotion
//----------------------------------------------------------------

- (BFTask *)createGuestlistForPromotion:(THLPromotionEntity *)promotionEntity withInvites:(NSArray *)guestPhoneNumbers {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSString *iso8601String = [dateFormatter stringFromDate:promotionEntity.event.date];
    
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    THLUser *currentUser = [THLUser currentUser];
    PFObject *guestlist = [PFObject objectWithClassName:@"Guestlist"];
    guestlist[@"Promotion"] = [THLPromotion objectWithoutDataWithObjectId:promotionEntity.objectId];
    guestlist[@"Owner"] = currentUser;
    guestlist[@"date"] = promotionEntity.time;
    guestlist[@"reviewStatus"] = [NSNumber numberWithInt:0];
    guestlist[@"eventId"] = promotionEntity.eventId;
    [guestlist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [PFCloud callFunctionInBackground:@"sendOutNotifications"
                               withParameters:@{@"promotionId": promotionEntity.objectId,
                                                @"eventName":promotionEntity.event.location.name,
                                                @"promotionTime":iso8601String,
                                                @"guestPhoneNumbers": guestPhoneNumbers,
                                                @"guestlistId": guestlist.objectId}
                                        block:^(id guestlistInvite, NSError *cloudError) {
                                            if (!cloudError){
                                                [completionSource setResult:nil];
                                            } else {
                                                [completionSource setError:cloudError];
                                            }
                                        }];
        } else {
            [completionSource setError:error];
        }
    }];
    return completionSource.task;
}

- (BFTask *)updateGuestlist:(NSString *)guestlistId withInvites:(NSArray *)guestPhoneNumbers forPromotion:(THLPromotionEntity *)promotionEntity {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [PFCloud callFunctionInBackground:@"sendOutNotifications"
                       withParameters:@{@"promotionId": promotionEntity.objectId,
                                        @"eventName":promotionEntity.event.location.name,
                                        @"promotionTime":promotionEntity.time,
                                        @"guestPhoneNumbers": guestPhoneNumbers,
                                        @"guestlistId": guestlistId}
                                block:^(id object, NSError *error) {
                                    
                                    if (!error){
                                        [completionSource setResult:nil];
                                    }else {
                                        [completionSource setError:error];
                                    }
                                }];
    return completionSource.task;
}

#pragma mark - Guestlist Invite Services

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists Invites For Guestlist
//----------------------------------------------------------------

- (BFTask *)fetchInvitesOnGuestlist:(THLGuestlist *)guestlist {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    NSMutableArray *completedGuestlistInvites = [NSMutableArray new];
    [[_queryFactory queryForInvitesOnGuestlist:guestlist] findObjectsInBackgroundWithBlock:^(NSArray *guestlistInvites, NSError *error) {
        for (PFObject *guestlistInvite in guestlistInvites) {
            PFObject *guest = guestlistInvite[@"Guest"];
            if (guest != nil) {
                [guestlistInvite setObject:guest forKey:@"guest"];
            }
            else {
                THLUser *dummyGuest = [THLUser new];
                dummyGuest.firstName = @"Pending Signup";
                [guestlistInvite setObject:dummyGuest forKey:@"guest"];
            }
            [completedGuestlistInvites addObject:guestlistInvite];
        }
        [completionSource setResult:completedGuestlistInvites];
    }];
    return completionSource.task;

}

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists For Guest For a Dashboard
//----------------------------------------------------------------

//TODO: Temporary - Only fetches first Accepted Guestlist Invite
- (BFTask *)fetchGuestlistInvitesForUser {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    __block NSMutableArray *completedGuestlistInvites = [NSMutableArray new];
    __block NSMutableArray *unfinishedGuestlistInvites = [NSMutableArray new];
    if ([THLUser currentUser]) {
        [[_queryFactory queryForGuestlistInvitesForUser] findObjectsInBackgroundWithBlock:^(NSArray *guestlistInvites, NSError *error) {
            if (!error) {
                for (PFObject *guestlistInvite in guestlistInvites) {
                    PFObject *guestlist = guestlistInvite[@"Guestlist"];
                    [guestlistInvite setObject:guestlist forKey:@"Guestlist"];
                    PFObject *promotion = guestlistInvite[@"Guestlist"][@"Promotion"];
                    [guestlist setObject:promotion forKey:@"Promotion"];
                    PFObject *host = guestlistInvite[@"Guestlist"][@"Promotion"][@"host"];
                    [promotion setObject:host forKey:@"host"];
                    PFObject *event = guestlistInvite[@"Guestlist"][@"Promotion"][@"event"];
                    [promotion setObject:event forKey:@"event"];
                    PFObject *location = guestlistInvite[@"Guestlist"][@"Promotion"][@"event"][@"location"];
                    [event setObject:location forKey:@"location"];
                    PFObject *guest = guestlistInvite[@"Guest"];
                    if (guest.isDataAvailable) {
                        [guestlistInvite setObject:guest forKey:@"Guest"];
                        [completedGuestlistInvites addObject:guestlistInvite];
                    } else {
                        [guestlistInvite setObject:[THLUser currentUser] forKey:@"Guest"];
                        [unfinishedGuestlistInvites addObject:guestlistInvite];
                    }
                }
                if (unfinishedGuestlistInvites.count > 0) {
                    [PFObject saveAllInBackground:unfinishedGuestlistInvites];
                    NSArray *joinedGuestlistInvites = [completedGuestlistInvites arrayByAddingObjectsFromArray:unfinishedGuestlistInvites];
                    [completionSource setResult:joinedGuestlistInvites];
                } else {
                    [completionSource setResult:completedGuestlistInvites];
                }
            } else {
                [completionSource setError:error];
            }
        }];
    } else {
        [completionSource setResult:nil];
    }

    return completionSource.task;
}


//----------------------------------------------------------------
#pragma mark - Fetch Guestlist For Guest For a Event/Promotion
//----------------------------------------------------------------

- (BFTask *)fetchGuestlistInviteForEvent:(THLEventEntity *)event {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [[_queryFactory queryForGuestlistInviteForEvent:event.objectId] getFirstObjectInBackgroundWithBlock:^(PFObject *guestlistInvite, NSError *error) {
        if (!error) {
            PFObject *guestlist = guestlistInvite[@"Guestlist"];
            [guestlistInvite setObject:guestlist forKey:@"Guestlist"];
            PFObject *owner = guestlistInvite[@"Guestlist"][@"Owner"];
            [guestlist setObject:owner forKey:@"Owner"];
            PFObject *promotion = guestlistInvite[@"Guestlist"][@"Promotion"];
            [guestlist setObject:promotion forKey:@"Promotion"];
            PFObject *fetchedEvent = guestlistInvite[@"Guestlist"][@"Promotion"][@"event"];
            [promotion setObject:fetchedEvent forKey:@"event"];
            PFObject *location = guestlistInvite[@"Guestlist"][@"Promotion"][@"event"][@"location"];
            [fetchedEvent setObject:location forKey:@"location"];
            [completionSource setResult:guestlistInvite];
        } else {
            [completionSource setError:error];
        }
    }];
    return completionSource.task;
}


//----------------------------------------------------------------
#pragma mark - Fetch Guestlists For Guest Using The Guestlist Invite ID
//----------------------------------------------------------------

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
            [completionSource setResult:guestlistInvite];
        } else {
            [completionSource setError:error];
        }
    }];
    return completionSource.task;
}

//----------------------------------------------------------------
#pragma mark - Update Guest's Guestlist Invite Response Status
//----------------------------------------------------------------

- (BFTask *)updateGuestlistInvite:(THLGuestlistInvite *)guestlistInvite withResponse:(THLStatus)response {
    NSNumber *castedResponse = [[NSNumber alloc] initWithInt:response];
    guestlistInvite[@"response"] = castedResponse;
    [guestlistInvite saveInBackground];
    return [BFTask taskWithResult:nil];
}

//----------------------------------------------------------------
#pragma mark - Update a Guestlist's Review Status
//----------------------------------------------------------------

- (BFTask *)updateGuestlist:(THLGuestlist *)guestlist withReviewStatus:(THLStatus)reviewStatus {
    guestlist[@"reviewStatus"] = [NSNumber numberWithInt:reviewStatus];
    [guestlist saveInBackground];
    return [BFTask taskWithResult:nil];
}


- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
