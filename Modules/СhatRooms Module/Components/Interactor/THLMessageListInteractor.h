//
//  THLMessageListInteractor.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLViewDataSourceFactoryInterface.h"
#import "THLMessageListDataManager.h"

@class THLMessageListDataManager;
@class THLMessageListInteractor;

@protocol THLMessageListInteractorDelegate <NSObject>
- (void)interactor:(THLMessageListInteractor *)interactor didUpdateChannels:(NSError *)error;
@end

@interface THLMessageListInteractor : NSObject

@property (nonatomic, weak) id<THLMessageListInteractorDelegate> delegate;

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLMessageListDataManager *dataManager;
- (instancetype)initWithDataManager:(THLMessageListDataManager *)dataManager
              viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory;
@property (nonatomic, readonly, weak) id<THLViewDataSourceFactoryInterface> viewDataSourceFactory;

- (THLViewDataSource *)generateDataSource;
- (THLViewDataSource *)generateMessageDataSource;
- (void)updateChannels;

@end
