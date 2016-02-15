//
//  THLGuestlistReviewWireframe.h
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLGuestlistReviewModuleInterface.h"

@protocol THLGuestlistServiceInterface;
@protocol THLViewDataSourceFactoryInterface;
@class THLDataStore;
@class THLEntityMapper;

@interface THLGuestlistReviewWireframe : NSObject
@property (nonatomic, readonly, weak) id<THLGuestlistReviewModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;

- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                            entityMapper:(THLEntityMapper *)entityMapper
                               dataStore:(THLDataStore *)dataStore
                   viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (void)presentInterfaceInController:(UIViewController *)controller;
- (void)presentInController:(UIViewController *)controller;
- (void)dismissInterface;
@end
