//
//  THLLoginServiceInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const kTHLFBSDKIdKey;
extern NSString *const kTHLFBSDKAboutKey;
extern NSString *const kTHLFBSDKAddressKey;
extern NSString *const kTHLFBSDKAge_rangeKey;
extern NSString *const kTHLFBSDKBioKey;
extern NSString *const kTHLFBSDKBirthdayKey;
extern NSString *const kTHLFBSDKCurrencyKey;
extern NSString *const kTHLFBSDKFirst_nameKey;
extern NSString *const kTHLFBSDKGenderKey;
extern NSString *const kTHLFBSDKLast_nameKey;
extern NSString *const kTHLFBSDKHometownKey;
extern NSString *const kTHLFBSDKLocationKey;
extern NSString *const kTHLFBSDKLocaleKey;
extern NSString *const kTHLFBSDKName_formatKey;
extern NSString *const kTHLFBSDKFullNameKey;
extern NSString *const kTHLFBSDKRelationship_statusKey;
extern NSString *const kTHLFBSDKVerifiedKey;
extern NSString *const kTHLFBSDKCoverKey;
extern NSString *const kTHLFBSDKEmailKey;

@class BFTask;
@protocol THLLoginServiceInterface <NSObject>
- (BFTask *)login;
- (BFTask *)getFacebookUserDictionary;
@end
