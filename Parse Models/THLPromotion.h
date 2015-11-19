//
//  THLPromotion.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
@class THLEvent;
@class THLUser;

@interface THLPromotion : PFObject<PFSubclassing>
@property (nonatomic, retain) NSDate *time;
@property (nonatomic) int maleRatio;
@property (nonatomic) int femaleRatio;
@property (nonatomic, retain) THLUser *host;
@property (nonatomic, retain) THLEvent *event;
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *promotionMessage;

@end
