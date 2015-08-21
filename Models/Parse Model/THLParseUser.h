//
//  THLParseUser.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
//@protocol PFSubclassing;

typedef NS_ENUM(NSInteger, THLParseUserType) {
	THLParseUserTypeGuest = 0,
	THLParseUserTypeHost = 1,
	THLParseUserTypeAdmin = 2,
	THLParseUserType_Count
};

typedef NS_ENUM(NSInteger, THLParseUserSex) {
	THLParseUserSexUnreported = 0,
	THLParseUserSexMale = 1,
	THLParseUserSexFemale = 2,
	THLParseUserSex_Count
};

@interface THLParseUser : PFUser<PFSubclassing>
@property (nonatomic, retain) NSString *fbId;
@property (nonatomic, retain) NSString *fbEmail;
@property (nonatomic, retain) NSDate *fbBirthday;
@property (nonatomic, retain) PFFile *image;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic) THLParseUserType type;
@property (nonatomic) THLParseUserSex sex;
@property (nonatomic) float rating;
@end
