//
//  THLPerkStoreWireframe.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkStoreModuleInterface.h"

@class THLDataStore;
@class THLEntityMapper;
@protocol THLPerkStoreItemServiceInterface;
@protocol THLViewDataSourceFactoryInterface;


@interface THLPerkStoreWireframe : NSObject
@property (nonatomic, readonly, weak) id<THLPerkStoreModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLPerkStoreItemServiceInterface> perkStoreItemService;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     entityMapper:(THLEntityMapper *)entityMapper
                     perkStoreItemService:(id<THLPerkStoreItemServiceInterface>)perkStoreItemService
            viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (void)presentPerkStoreInterfaceInNavigationController:(UINavigationController *)navigationController;
- (void)dismissInterface;
@end
