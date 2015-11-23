//
//  THLEventHostingWireframe.h
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "THLEventHostingModuleInterface.h"

@class THLDataStore;
@class THLEntityMapper;
@protocol THLGuestlistServiceInterface;
@protocol THLViewDataSourceFactoryInterface;

@interface THLEventHostingWireframe : NSObject
@property (nonatomic, readonly, weak) id<THLEventHostingModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) id<THLGuestlistServiceInterface> guestlistService;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;

- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                 guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
            viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory
                    entityMappper:(THLEntityMapper *)entityMapper;

- (void)presentInterfaceInWindow:(UIWindow *)window;
- (void)dismissInterface;
@end