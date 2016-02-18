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
@property (nonatomic) float maleCoverCharge;
@property (nonatomic) float femaleCoverCharge;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *promoInfo;
@property (nonatomic, retain) PFFile *promoImage;
@property (nonatomic) int creditsPayout;
@property (nonatomic, retain) THLLocation *location;
@property (nonatomic, retain) THLUser *host;
@property (nonatomic) bool requiresApproval;
@property (nonatomic) int maleRatio;
@property (nonatomic) int femaleRatio;
@property (nonatomic, retain) NSString *chatMessage;
@end
