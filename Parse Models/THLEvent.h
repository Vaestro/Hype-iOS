//
//  THLEvent.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "THLLocation.h"
@class THLUser;

@interface THLEvent : PFObject<PFSubclassing>
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) THLLocation *location;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *promoInfo;
@property (nonatomic, retain) PFFile *promoImage;
@property (nonatomic, retain) NSArray<PFObject *> *admissionOptions;
@property (nonatomic) int creditsPayout;
@property (nonatomic) int ageRequirement;
@property (nonatomic) BOOL featured;

@end
