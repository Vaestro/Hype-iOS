//
//  THLPerkDetailDataManager.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;
@class THLPerkStoreItem;
@class THLPerkStoreItemEntity;
@class THLEntityMapper;
@class THLUser;

@protocol THLPerkStoreItemServiceInterface;


@interface THLPerkDetailDataManager : NSObject

#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLPerkStoreItemServiceInterface> perkStoreItemService;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
- (instancetype)initWithPerkStoreItemService:(id<THLPerkStoreItemServiceInterface>)perkStoreItemService
                                entityMapper:(THLEntityMapper *)entityMapper;


- (BFTask *)purchasePerkStoreItem:(THLPerkStoreItemEntity *)perkStoreItem;
@end
