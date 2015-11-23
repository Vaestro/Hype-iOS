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
                                                @"promotionTime":iso8601String,
                                                @"guestPhoneNumbers": guestPhoneNumbers,
                                                @"guestlistId": guestlist.objectId}
                                        block:^(id object, NSError *cloudError) {
                                            
                                            if (!cloudError){
                                                guestlistInvite[@"Guest"] = currentUser;
                                                guestlistInvite[@"Guestlist"] = guestlist;
                                                guestlistInvite[@"phoneNumber"] = currentUser.phoneNumber;
                                                guestlistInvite[@"response"] = [NSNumber numberWithInt:1];
                                                guestlistInvite[@"checkInStatus"] = [NSNumber numberWithBool:FALSE];
                                                guestlistInvite[@"date"] = promotionEntity.event.date;
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
            } else {
                THLUser *dummyGuest = [THLUser new];
//                UIImage *image = [[UIImage imageNamed:@"Hypelist-Icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//                NSData *fileData = UIImagePNGRepresentation(image);
//                PFFile *file = [PFFile fileWithName:@"dummyImage" data:fileData];
//                dummyGuest.image = file;
                dummyGuest.firstName = @"Pending Signup";
                [guestlistInvite setObject:dummyGuest forKey:@"guest"];
            }
//            [guestlistInvite setObject:parentGuestlist forKey:@"guestlist"];
            [completedGuestlistInvites addObject:guestlistInvite];
        }
        [completionSource setResult:completedGuestlistInvites];
    }];
    return completionSource.task;

}

//----------------------------------------------------------------
#pragma mark - Fetch Guestlist For Guest For a Event/Promotion
//----------------------------------------------------------------

- (BFTask *)fetchGuestlistInviteForUser:(THLUser *)user atEvent:(THLEventEntity *)event {
    return [[_queryFactory queryForGuestlistInviteForUser:user atEvent:event.objectId] getFirstObjectInBackground];
//    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
//    [PFCloud callFunctionInBackground:@"guestlistAvailability"
//                       withParameters:@{@"minTime":[event.date dateByAddingTimeInterval:-60*180],
//                                        @"maxTime":[event.date dateByAddingTimeInterval:60*180]}
//                                block:^(id object, NSError *error) {
//                                    if (object == [NSNumber numberWithBool:YES]){
//                                        [[_queryFactory queryForGuestlistInviteForUser:user atEvent:event.objectId] getFirstObjectInBackgroundWithBlock:^(PFObject *guestlistInvite, NSError *fetchError) {
//                                            if (guestlistInvite != nil) {
//                                                [completionSource setResult:guestlistInvite];
//                                            } else {
//                                                [completionSource setResult:nil];
//                                            }
//                                        }];
//                                    } else if (object == [NSNumber numberWithBool:NO]){
//                                        [completionSource setResult:[NSNumber numberWithBool:NO]];
//                                    } else {
//                                        [completionSource setError:error];
//                                    }
//                                }];
//    return completionSource.task;
}

//----------------------------------------------------------------
#pragma mark - Fetch Guestlists For Guest For a Dashboard
//----------------------------------------------------------------

//TODO: Temporary - Only fetches first Accepted Guestlist Invite
- (BFTask *)fetchGuestlistInvitesForUser {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [[_queryFactory queryForGuestlistInvitesForUser] getFirstObjectInBackgroundWithBlock:^(PFObject *guestlistInvite, NSError *error) {
        if (!error) {
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
            [guestlistInvite pinInBackgroundWithName:@"GuestlistInvites"];
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
            [guestlistInvite pinInBackgroundWithName:@"GuestlistInvites"];
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
