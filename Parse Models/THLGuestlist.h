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
@class THLEvent;

@interface THLGuestlist : PFObject<PFSubclassing>
@property (nonatomic, retain) THLUser *owner;
@property (nonatomic, retain) THLEvent *event;
@property (nonatomic) THLStatus reviewStatus;
@property (nonatomic, copy) NSDate *date;
@end
