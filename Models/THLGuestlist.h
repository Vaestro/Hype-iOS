//
//  THLGuestlist.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/2/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>


@class THLUser;
@class THLPromotion;
@interface THLGuestlist : PFObject<PFSubclassing>
@property (nonatomic, retain) THLUser *owner;
@property (nonatomic, retain) THLPromotion *promotion;
@end
