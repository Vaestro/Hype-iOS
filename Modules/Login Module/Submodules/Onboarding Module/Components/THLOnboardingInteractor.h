//
//  THLOnboardingInteractor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/19/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLUser;
@class THLOnboardingInteractor;

@protocol THLOnboardingInteractorDelegate <NSObject>
- (void)interactor:(THLOnboardingInteractor *)interactor didUpdateUser:(THLUser *)user withPhoneNumber:(NSString *)phoneNumber error:(NSError *)error;
- (void)interactor:(THLOnboardingInteractor *)interactor didUpdateUser:(THLUser *)user withProfileImage:(UIImage *)profileImage error:(NSError *)error;

@end

@interface THLOnboardingInteractor : NSObject
@property (nonatomic, weak) id<THLOnboardingInteractorDelegate> delegate;

- (void)updateUser:(THLUser *)user withPhoneNumber:(NSString *)phoneNumber;
- (void)updateUser:(THLUser *)user withProfileImage:(UIImage *)profileImage;

@end
