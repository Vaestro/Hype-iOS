//
//  THLAdmissionOption.h
//  Hype
//
//  Created by Edgar Li on 6/10/16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
@class THLLocation;

@interface THLAdmissionOption : PFObject<PFSubclassing>
@property (nonatomic, retain) NSNumber *gender;
@property (nonatomic, retain) THLLocation *location;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSNumber *type;
@property (nonatomic, retain) NSString *venue;

@end
