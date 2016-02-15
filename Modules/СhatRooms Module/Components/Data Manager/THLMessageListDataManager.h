//
//  THLMessageListDataManager.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLMessageListServiceInterface.h"

@class THLDataStore;
@class THLEntityMapper;
@class BFTask;
@protocol THLMessageListServiceInterface;

@interface THLMessageListDataManager : NSObject
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) THLDataStore *dataStore;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) id<THLMessageListServiceInterface> messageListService;

- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                     entityMapper:(THLEntityMapper *)entityMapper
                     messageList:(id<THLMessageListServiceInterface>)messageListService;

- (BFTask *)fetchAllChannels;

@end
