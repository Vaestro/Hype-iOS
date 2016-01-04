//
//  THLLocationEntity.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"

@interface THLLocationEntity : THLEntity
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *stateCode;
@property (nonatomic, copy) NSString *zipcode;
@property (nonatomic, copy) NSString *neighborhood;
@property (nonatomic, copy) NSArray *musicTypes;
@property (nonatomic, copy) NSString *attireRequirement;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;

@property (nonatomic, readonly) NSString *fullAddress;
@end
