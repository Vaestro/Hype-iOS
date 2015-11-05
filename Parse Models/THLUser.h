//
//  THLUser.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "THLConstants.h"
//@protocol PFSubclassing;

typedef NS_ENUM(NSInteger, THLUserType) {
	THLUserTypeGuest = 0,
	THLUserTypeHost = 1,
	THLUserTypeAdmin = 2,
	THLUserType_Count
};


@interface THLUser : PFUser<PFSubclassing>
@property (nonatomic, retain) NSString *fbId;
@property (nonatomic, retain) NSString *fbEmail;
@property (nonatomic, retain) NSDate *fbBirthday;
@property (nonatomic, retain) PFFile *image;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic) enum THLUserType type;
@property (nonatomic) enum THLSex sex;
@property (nonatomic) float rating;

@property (nonatomic, copy, readonly) NSString *fullName;
@end
