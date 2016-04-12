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
#import "THLEventEntity.h"
#import "THLEvent.h"
#import "THLLocationEntity.h"
#import "THLUser.h"
#import "THLBeaconEntity.h"
#import "THLPubnubManager.h"
#import "THLChannelService.h"
#import "THLHostEntity.h"
#import "THLBeacon.h"
#import "THLEntityMapper.h"
#import "THLGuestEntity.h"


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

- (BFTask *)fetchGuestlistsForEvent:(NSString *)eventId {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    NSMutableArray *completedGuestlists = [NSMutableArray new];
    [[_queryFactory queryForGuestlistsForEvent:eventId] findObjectsInBackgroundWithBlock:^(NSArray *guestlists, NSError *error) {
        for (PFObject *guestlist in guestlists) {
            PFObject *event = guestlist[@"event"];
            [guestlist setObject:event forKey:@"event"];
            PFObject *host = guestlist[@"event"][@"host"];
            PFObject *location = guestlist[@"event"][@"location"];
            if (host != nil) {
                [event setObject:host forKey:@"host"];
                [event setObject:location forKey:@"location"];
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
            PFObject *event = guestlist[@"event"];
            [guestlist setObject:event forKey:@"event"];
            PFObject *host = guestlist[@"event"][@"host"];
            if (host != nil) {
                [event setObject:host forKey:@"host"];
            }
            [completedGuestlists addObject:guestlist];
        }
        [completionSource setResult:completedGuestlists];
    }];
    return completionSource.task;
}

//----------------------------------------------------------------
#pragma mark - Fetch Guestlist For Guest Using The Guestlist ID
////----------------------------------------------------------------
- (BFTask *)fetchGuestlistWithId:(NSString *)guestlistId {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [[_queryFactory queryForGuestlistWithId] getObjectInBackgroundWithId:guestlistId block:^(PFObject *guestlist, NSError *error) {
        if (!error) {
            PFObject *event = guestlist[@"event"];
            PFObject *host = guestlist[@"event"][@"host"];
            PFObject *location = guestlist[@"event"][@"location"];
            [event setObject:host forKey:@"host"];
            [event setObject:location forKey:@"location"];
            [guestlist setObject:event forKey:@"event"];
            
            
            if (host != nil) {
                
                
            }
        } else {
            [completionSource setError:error];
        }
    }];
    return completionSource.task;
}

//----------------------------------------------------------------
#pragma mark - Create Guestlist For Event
//----------------------------------------------------------------

- (BFTask *)createGuestlistForEvent:(THLEventEntity *)eventEntity withInvites:(NSArray *)guestPhoneNumbers {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSString *iso8601String = [dateFormatter stringFromDate:eventEntity.date];
    
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    THLUser *currentUser = [THLUser currentUser];
    PFObject *guestlist = [PFObject objectWithClassName:@"Guestlist"];
    guestlist[@"Owner"] = currentUser;
    guestlist[@"date"] = eventEntity.date;
    
    if (eventEntity.requiresApproval) {
        guestlist[@"reviewStatus"] = [NSNumber numberWithInt:2];
    } else {
        guestlist[@"reviewStatus"] = [NSNumber numberWithInt:0];
    }
    
    guestlist[@"event"] = [THLEvent objectWithoutDataWithObjectId:eventEntity.objectId];
    [guestlist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [PFCloud callFunctionInBackground:@"sendOutNotifications"
                               withParameters:@{@"eventId": eventEntity.objectId,
                                                @"eventName":eventEntity.location.name,
                                                @"eventTime":iso8601String,
                                                @"guestPhoneNumbers": guestPhoneNumbers,
                                                @"guestlistId": guestlist.objectId}
                                        block:^(id knownGuestIds, NSError *cloudError) {
                                            if (!cloudError){
                                                [completionSource setResult:nil];
                                                
                                                NSArray *knownGuests = knownGuestIds;
                                                
                                                THLChannelService *service = [[THLChannelService alloc] init];
                                                
                                                
                                                if (knownGuests.count > 0)  {
                                                    for (id guestId in knownGuests) {
                                                        [service createChannelForOwner:guestId andHost:eventEntity.host.objectId withGuestlist:guestlist.objectId expireEvent:eventEntity.date.thl_sixHoursAhead];
                                                    }
                                                    
                                                    [[THLPubnubManager sharedInstance] publishFirstMessageFromChannel:[NSString stringWithFormat:@"%@_Host", guestlist.objectId] withHost:eventEntity.host andChatMessage:eventEntity.chatMessage];
                                                }
                                                
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

- (BFTask *)updateGuestlist:(NSString *)guestlistId withInvites:(NSArray *)guestPhoneNumbers forEvent:(THLEventEntity *)eventEntity {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [PFCloud callFunctionInBackground:@"sendOutNotifications"
                       withParameters:@{@"eventId": eventEntity.objectId,
                                        @"eventName":eventEntity.location.name,
                                        @"eventTime": eventEntity.date,
                                        @"guestPhoneNumbers": guestPhoneNumbers,
                                        @"guestlistId": guestlistId}
                                block:^(id knownGuestIds, NSError *error) {
                                    
                                    if (!error){
                                        [completionSource setResult:nil];
                                        
                                        NSArray *knownGuests = knownGuestIds;
                                        
                                        THLChannelService *service = [[THLChannelService alloc] init];
                                        
                                        if (knownGuests.count > 0)  {
                                            for (id guestId in knownGuests) {
                                                [service createChannelForOwner:guestId andHost:eventEntity.host.objectId withGuestlist:guestlistId expireEvent:eventEntity.date.thl_sixHoursAhead];
                                            }
                                        }
                                        
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
                    PFObject *event= guestlistInvite[@"Guestlist"][@"event"];
                    [guestlist setObject:event forKey:@"event"];
                    PFObject *host = guestlistInvite[@"Guestlist"][@"event"][@"host"];
                    [event setObject:host forKey:@"host"];
                    PFObject *location = guestlistInvite[@"Guestlist"][@"event"][@"location"];
                    [event setObject:location forKey:@"location"];
                    PFObject *guest = guestlistInvite[@"Guest"];
                    if (guest.isDataAvailable) {
                        [guestlistInvite setObject:guest forKey:@"Guest"];
                        [completedGuestlistInvites addObject:guestlistInvite];
                    } else {
                        [guestlistInvite setObject:[THLUser currentUser] forKey:@"Guest"];
#warning INVITATION CODES SHOULD NOT BE SET TO NIL HERE (BAD CODE)
                        [guestlistInvite setValue:nil forKey:@"invitationCode"];
                        [guestlistInvite setValue:[NSNumber numberWithInt:2] forKey:@"response"];
                        THLChannelService *service = [[THLChannelService alloc] init];
                        [service createChannelForGuest:[THLUser currentUser].objectId withGuestlist:guestlist.objectId expireEvent:event[@"date"]];
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
            PFObject *fetchedEvent = guestlistInvite[@"Guestlist"][@"event"];
            [guestlist setObject:fetchedEvent forKey:@"event"];
            PFObject *location = guestlistInvite[@"Guestlist"][@"event"][@"location"];
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
            PFObject *event = guestlistInvite[@"Guestlist"][@"event"];
            [guestlist setObject:event forKey:@"event"];
            PFObject *location = guestlistInvite[@"Guestlist"][@"event"][@"location"];
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
#pragma mark - Update Guest's Guestlist Invite To Opened
//----------------------------------------------------------------


- (BFTask *)updateGuestlistInviteToOpened:(THLGuestlistInvite *)guestlistInvite {
    guestlistInvite[@"didOpen"] = @YES;
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


//----------------------------------------------------------------
#pragma mark - Update a Guestlist Invite's Check In Status
//----------------------------------------------------------------
- (BFTask *)updateGuestlistInvite:(THLGuestlistInvite *)guestlistInvite withCheckInStatus:(BOOL)status {
    guestlistInvite[@"checkInStatus"] = [NSNumber numberWithBool:status];
    [guestlistInvite saveInBackground];
    return [BFTask taskWithResult:nil];
}



- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
