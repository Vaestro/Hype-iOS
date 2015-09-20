//
//  THLFacebookPictureInteractor.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLFacebookPictureInteractor;
@protocol THLFacebookPictureInteractorDelegate <NSObject>
- (void)interactor:(THLFacebookPictureInteractor *)interactor didGetProfileImage:(UIImage *)image error:(NSError *)error;
@end

@class THLFacebookProfilePictureURLFetchService;

@interface THLFacebookPictureInteractor : NSObject
@property (nonatomic, weak) id<THLFacebookPictureInteractorDelegate> delegate;
@property (nonatomic, readonly) THLFacebookProfilePictureURLFetchService *fetchService;

- (instancetype)initWithFetchService:(THLFacebookProfilePictureURLFetchService *)service;

- (void)getProfileImage;
@end
