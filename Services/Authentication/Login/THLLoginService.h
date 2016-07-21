//
//  THLLoginService.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLLoginServiceDelegate <NSObject>

-(void)loginServiceDidLoginUser;
-(void)loginServiceNeedsUserToSignup;

-(void)loginServiceDidSignupUser;
-(void)loginServiceNeedsUserToLogin;

@end

@interface THLLoginService : NSObject
@property (nonatomic, weak) id<THLLoginServiceDelegate> delegate;
@property (nonatomic, strong) UINavigationController *navigationController;

- (void)login;
- (void)loginWithFacebook;
- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;

- (void)signUpWithFacebook;
- (void)signUpWithEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName sex:(THLSex)sex;

- (void)createMixpanelAlias;
- (void)createMixpanelPeopleProfile;
- (void)saveFacebookUserInformation;
- (BOOL)shouldLogin;
- (BOOL)shouldAddFacebookInformation;
- (BOOL)shouldVerifyEmail;
- (BOOL)shouldVerifyPhoneNumber;
@end
