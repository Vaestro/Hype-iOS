//
//  THLGuestEntity.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestEntity.h"
#import "APContact.h"
#import "APName.h"
#import "APPhone.h"
#import "THLUserEntity.h"
#import "NBPhoneNumberUtil.h"

@implementation THLGuestEntity
@synthesize objectId = _objectId;

- (instancetype)initWithContact:(APContact *)contact {
	if (self = [super init]) {   
		_firstName = [contact.name.firstName copy];
		_lastName = [contact.name.lastName copy];
		_phoneNumber = [[contact.phones objectAtIndex:0].number copy];
		_type = THLGuestEntityTypeLocalContact;
		_objectId = [NSString stringWithFormat:@"contact%lu", (unsigned long)self.phoneNumber.hash];
	}
	return self;
}

- (instancetype)initWithUser:(THLUserEntity *)user {
	if (self = [super init]) {
		_firstName = [user.firstName copy];
		_lastName = [user.lastName copy];
		_phoneNumber = [user.phoneNumber copy];
		_type = THLGuestEntityTypeRemoteUser;
		_objectId = [user.objectId copy];
	}
	return self;
}

+ (instancetype)fromContact:(APContact *)contact {
	THLGuestEntity *entity = [[THLGuestEntity alloc] initWithContact:contact];
	return entity;
}

+ (instancetype)fromUser:(THLUserEntity *)user {
	THLGuestEntity *entity = [[THLGuestEntity alloc] initWithUser:user];
	return entity;
}

- (NSString *)fullName {
    NSString *fullName;
    if (_firstName != NULL && _lastName != NULL) {
        fullName = [[NSString stringWithFormat:@"%@ %@", _firstName, _lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    } else if (_firstName != NULL && _lastName == NULL){
        fullName = _firstName;
    } else if (_firstName == NULL && _lastName != NULL){
        fullName = _lastName;
    }
    return fullName;
}

- (NSString *)intPhoneNumberFormat {
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:_phoneNumber
                                 defaultRegion:@"US" error:&anError];
    
//    if (anError == nil) {
        // Should check error
//        NSLog(@"isValidPhoneNumber ? [%@]", [phoneUtil isValidNumber:myNumber] ? @"YES":@"NO");
        
        // E164          : +436766077303
        return [NSString stringWithFormat:@"%@", [phoneUtil format:myNumber
                                          numberFormat:NBEPhoneNumberFormatE164
                                                 error:&anError]];
        // INTERNATIONAL : +43 676 6077303
//        NSLog(@"INTERNATIONAL : %@", [phoneUtil format:myNumber
//                                          numberFormat:NBEPhoneNumberFormatINTERNATIONAL
//                                                 error:&anError]);

//    } else {
//        NSLog(@"Error : %@", [anError localizedDescription]);
//    }
    
//    return [NSString stringWithFormat:@"+%@", [[_phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];
}
@end
