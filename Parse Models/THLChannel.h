//
//  THLChannel.h
//  Hype
//
//  Created by Александр on 13.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>


@class THLUser;
@class THLEvent;
@class THLGuestlist;

@interface THLChannel : PFObject<PFSubclassing>

//@property (nonatomic, strong) NSString *channelName;
@property (nonatomic, strong) THLUser *hostId;
@property (nonatomic, strong) THLUser *guestId;
@property (nonatomic, strong) THLUser *ownerId;
@property (nonatomic, strong) THLEvent *eventId;
@property (nonatomic, strong) THLGuestlist *guestlistId;

@end
