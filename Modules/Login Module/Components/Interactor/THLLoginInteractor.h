//
//  THLLoginInteractor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLLoginDataManager;
@class THLLoginInteractor;
@class THLUserManager;
@class THLUser;

@protocol THLLoginInteractorDelegate <NSObject>
- (void)interactor:(THLLoginInteractor *)interactor didLoginUser:(NSError *)error;
- (void)interactor:(THLLoginInteractor *)interactor didAddFacebookInformation:(NSError *)error;
- (void)interactor:(THLLoginInteractor *)interactor didAddEmail:(NSError *)error;
- (void)interactor:(THLLoginInteractor *)interactor didAddVerifiedPhoneNumber:(NSError *)error;
- (void)interactor:(THLLoginInteractor *)interactor didAddProfileImage:(NSError *)error;
@end

@interface THLLoginInteractor : NSObject
@property (nonatomic, weak) id<THLLoginInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLLoginDataManager *dataManager;
@property (nonatomic, readonly, weak) THLUserManager *userManager;
@property (nonatomic, strong) THLUser *user;


- (instancetype)initWithDataManager:(THLLoginDataManager *)dataManager
						userManager:(THLUserManager *)userManager;

- (BOOL)shouldLogin;
- (BOOL)shouldAddFacebookInformation;
- (BOOL)shouldVerifyEmail;
- (BOOL)shouldVerifyPhoneNumber;

- (void)login;
- (void)addEmail:(NSString *)email;
- (void)addFacebookInformation;
- (void)createMixPanelUserProfile;
- (void)addVerifiedPhoneNumber:(NSString *)phoneNumber;
@end
