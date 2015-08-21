//
//  THLParseEvent.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@class THLParseLocation;

@interface THLParseEvent : PFObject<PFSubclassing>
@property (nonatomic, retain) NSDate *date;
@property (nonatomic) float maleCoverCharge;
@property (nonatomic) float femaleCoverCharge;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *promoInfo;
@property (nonatomic, retain) PFFile *promoImage;
@property (nonatomic, retain) THLParseLocation *location;
@end
