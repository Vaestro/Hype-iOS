//
//  THLInquiry.h
//  Hype
//
//  Created by Edgar Li on 10/6/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "THLGuestlist.h"
#import "THLUser.h"

@interface THLInquiry : PFObject<PFSubclassing>
@property (nonatomic, retain) THLGuestlist *guestlist;
@property (nonatomic, retain) THLUser *owner;
@property (nonatomic, retain) THLUser *matchedPromoter;
@property (nonatomic, retain) NSArray<PFObject *> *interestedPromoters;
@end
