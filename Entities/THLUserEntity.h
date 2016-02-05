//
//  THLUserEntity.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
@class THLBeacon;

@interface THLUserEntity : THLEntity
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;
//@property (nonatomic, readonly) UIImage *thumbnail;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic) enum THLSex sex;
@property (nonatomic) float rating;
@property (nonatomic) float credits;
@property (nonatomic, strong) NSString *twilioNumber;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *intPhoneNumberFormat;
@property (nonatomic, strong) THLBeacon *beacon;
@end
