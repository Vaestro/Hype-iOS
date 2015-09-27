//
//  THLLocation.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>


@interface THLLocation : PFObject<PFSubclassing>
@property (nonatomic, retain) PFFile *image;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *info;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *stateCode;
@property (nonatomic, retain) NSString *zipcode;
@property (nonatomic, retain) NSString *neighborhood;
@property (nonatomic, retain) PFGeoPoint *coordinate;

@end
