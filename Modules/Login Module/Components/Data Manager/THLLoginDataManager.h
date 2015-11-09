//
//  THLLoginDataManager.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLLoginServiceInterface;

@interface THLLoginDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLLoginServiceInterface> loginService;
- (instancetype)initWithLoginService:(id<THLLoginServiceInterface>)loginService;

- (BFTask *)login;
- (BFTask *)getFacebookInformation;
@end
