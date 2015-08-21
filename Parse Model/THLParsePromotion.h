//
//  THLParsePromotion.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@class THLParseUser;
@class THLParseEvent;

@interface THLParsePromotion : PFObject<PFSubclassing>
@property (nonatomic, retain) NSDate *time;
@property (nonatomic) int maleRatio;
@property (nonatomic) int femaleRatio;
@property (nonatomic, retain) THLParseUser *host;
@property (nonatomic, retain) THLParseEvent *event;
@property (nonatomic, retain) NSString *eventId;
@end
