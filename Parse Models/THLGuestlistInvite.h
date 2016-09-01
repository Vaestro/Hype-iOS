//
//  THLGuestlistInvite.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "THLGuestlist.h"
#import "THLUser.h"

@interface THLGuestlistInvite : PFObject<PFSubclassing>
@property (nonatomic, retain) THLUser *guest;
@property (nonatomic, retain) THLUser *sender;

@property (nonatomic, retain) THLGuestlist *guestlist;
@property (nonatomic, retain) THLEvent *event;

@property (nonatomic, copy) NSDate *date;
@property (nonatomic) THLStatus response;
@property (nonatomic) BOOL didOpen;
@property (nonatomic) BOOL checkInStatus;
@property (nonatomic, retain) NSString *invitationCode;
@property (nonatomic, retain) NSString *admissionDescription;

@property (nonatomic, retain) PFFile *qrCode;
@end
