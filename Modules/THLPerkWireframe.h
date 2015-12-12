//
//  THLPerkWireframe.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkModuleInterface.h"

@class THLDataStore;
@class THLEntityMapper;
@protocol THLPerkItemStoreServiceInterface;
@protocol THLViewDataSourceFactoryInterface;


@interface THLPerkWireframe : NSObject
@property (nonatomic, readonly, weak) id<THLPerkModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLPerkItemStoreServiceInterface> perkItemStoreService;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     entityMapper:(THLEntityMapper *)entityMapper
                     perkItemStoreService:(id<THLPerkItemStoreServiceInterface>)perkItemStoreService
            viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (void)presentPerkInterfaceInWindow:(UIWindow *)window;
- (void)dismissInterface;
@end
