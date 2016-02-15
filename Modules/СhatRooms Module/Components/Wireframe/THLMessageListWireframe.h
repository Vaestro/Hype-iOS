//
//  THLMessageListWireframe.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLMessageListModuleInterface.h"

@class THLDataStore;
@class THLEntityMapper;
@protocol THLMessageListServiceInterface;
@protocol THLViewDataSourceFactoryInterface;

@interface THLMessageListWireframe : NSObject
@property (nonatomic, readonly, weak) id<THLMessageListModuleInterface> moduleInterface;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLMessageListServiceInterface> messageListService;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     entityMapper:(THLEntityMapper *)entityMapper
                     messageListService:(id<THLMessageListServiceInterface>)messageListService
            viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;

- (void)presentInNavigationController:(UINavigationController *)navigationController;
- (void)presentChatInNavigationController:(UINavigationController *)navigationController;

@end
