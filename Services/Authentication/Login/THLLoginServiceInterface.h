//
//  THLLoginServiceInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;


@protocol THLLoginServiceInterface <NSObject>

- (BFTask *)login;
- (BFTask *)getFacebookUserDictionary;
- (void)saveFacebookUserInformation;
- (BOOL)shouldLogin;
- (BOOL)shouldAddFacebookInformation;
- (BOOL)shouldVerifyEmail;
- (BOOL)shouldVerifyPhoneNumber;
@end
