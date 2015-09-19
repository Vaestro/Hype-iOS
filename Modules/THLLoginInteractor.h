//
//  THLLoginInteractor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLUserLoginServiceInterface;
@class THLLoginInteractor;
@class THLUser;

@protocol THLLoginInteractorDelegate <NSObject>
- (void)interactor:(THLLoginInteractor *)interactor didLoginUser:(THLUser *)user error:(NSError *)error;
@end

@interface THLLoginInteractor : NSObject
@property (nonatomic, weak) id<THLLoginInteractorDelegate> delegate;
@property (nonatomic, strong, readonly) id<THLUserLoginServiceInterface> loginService;

- (instancetype)initWithLoginService:(id<THLUserLoginServiceInterface>)loginService;
- (void)login;
@end
