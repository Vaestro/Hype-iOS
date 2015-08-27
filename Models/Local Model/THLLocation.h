//
//  THLLocation.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"

@interface THLLocation : THLEntity
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic, copy) NSString *neighborhood;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@property (nonatomic, readonly) NSString *fullAddress;
@end
