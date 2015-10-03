//
//  THLGuestEntity.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"

typedef NS_ENUM(NSInteger, THLGuestEntityType) {
	THLGuestEntityTypeLocalContact = 0,
	THLGuestEntityType_Count
};

@interface THLGuestEntity : THLEntity
@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *phoneNumber;
@property (nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) THLGuestEntityType type;
@end
