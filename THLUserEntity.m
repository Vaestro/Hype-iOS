//
//  THLUserEntity.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserEntity.h"
#import "NBPhoneNumberUtil.h"

@implementation THLUserEntity


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
