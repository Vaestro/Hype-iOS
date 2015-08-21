//
//  THLUser.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"

@interface THLUser : THLEntity
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic) float rating;

@property (nonatomic, readonly) NSString *fullName;
@end
