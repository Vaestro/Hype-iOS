//
//  THLGuestlistTicket.h
//  Hype
//
//  Created by Daniel Aksenov on 5/8/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
@class THLGuestlist;
@class THLUser;

@interface THLGuestlistTicket : PFObject<PFSubclassing>
@property (nonatomic, retain) THLUser *sender;
@property (nonatomic, retain) THLGuestlist *guestlist;
@property (nonatomic, retain) PFFile *qrCode;
@property (nonatomic) bool scanned;
@end
