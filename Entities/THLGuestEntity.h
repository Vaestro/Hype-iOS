//
//  THLGuestEntity.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntity.h"
#import "THLUserEntity.h"

@class APContact;

typedef NS_ENUM(NSInteger, THLGuestEntityType) {
	THLGuestEntityTypeLocalContact = 0,
	THLGuestEntityTypeRemoteUser,
	THLGuestEntityType_Count
};

@interface THLGuestEntity : THLUserEntity

@property (nonatomic, readonly) THLGuestEntityType type;

+ (instancetype)fromContact:(APContact *)contact;
+ (instancetype)fromUser:(THLUserEntity *)user;
@end
