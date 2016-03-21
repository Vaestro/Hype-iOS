//
//  THLChannelService.m
//  HypeUp
//
//  Created by Александр on 14.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLChannelService.h"
#import <Parse/Parse.h>
#import "THLUser.h"
#import "THLGuestlist.h"
#import "THLUser.h"

@implementation THLChannelService

- (void)createChannelForGuest:(NSString *)guestId withGuestlist:(NSString *)guestlistId expireEvent:(NSDate *)date {
    
    PFObject *channel = [PFObject objectWithClassName:@"Channel"];
    channel[@"guestId"] = [THLUser objectWithoutDataWithObjectId:guestId];
    channel[@"guestlistId"] = [THLGuestlist objectWithoutDataWithObjectId:guestlistId];
    channel[@"date"] = date;
    [channel saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        //
    }];
}

- (void)createChannelForOwner:(NSString *)ownerId andHost:(NSString *)hostId
                withGuestlist:(NSString *)guestlistId expireEvent:(NSDate *)date {
    PFObject *channel = [PFObject objectWithClassName:@"Channel"];
    channel[@"ownerId"] = [THLUser objectWithoutDataWithObjectId:ownerId];
    channel[@"hostId"] = [THLUser objectWithoutDataWithObjectId:hostId];
    channel[@"guestlistId"] = [THLGuestlist objectWithoutDataWithObjectId:guestlistId];
    channel[@"date"] = date;
    [channel saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        //
    }];
}

@end
