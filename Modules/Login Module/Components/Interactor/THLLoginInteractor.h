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
@class THLUser;

@protocol THLLoginInteractorDelegate <NSObject>
- (void)interactor:(THLLoginInteractor *)interactor didLoginUser:(NSError *)error;
- (void)interactor:(THLLoginInteractor *)interactor didAddVerifiedPhoneNumber:(NSError *)error;
- (void)interactor:(THLLoginInteractor *)interactor didAddProfileImage:(NSError *)error;
@end

@interface THLLoginInteractor : NSObject
@property (nonatomic, weak) id<THLLoginInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly) THLLoginDataManager *dataManager;
- (instancetype)initWithDataManager:(THLLoginDataManager *)dataManager;

- (BOOL)shouldLogin;
- (BOOL)shouldVerifyPhoneNumber;
- (BOOL)shouldPickProfileImage;

- (void)login;
- (void)addVerifiedPhoneNumber:(NSString *)phoneNumber;
- (void)addProfileImage:(UIImage *)profileImage;
@end
