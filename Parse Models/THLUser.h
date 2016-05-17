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

@interface THLUser : PFUser<PFSubclassing>
@property (nonatomic, retain) NSString *fbId;
@property (nonatomic, retain) NSString *fbEmail;
@property (nonatomic, retain) NSDate *fbBirthday;
@property (nonatomic, retain) PFFile *image;
//@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *location;
@property (nonatomic) BOOL fbVerified;
@property (nonatomic) enum THLUserType type;
@property (nonatomic) enum THLSex sex;
@property (nonatomic) float rating;
@property (nonatomic) float credits;
@property (nonatomic, retain) NSString *twilioNumber;
@property (nonatomic, copy, readonly) NSString *fullName;
@property (nonatomic, retain) NSString *stripeCustomerId;
- (NSString *)fullName;
@end
