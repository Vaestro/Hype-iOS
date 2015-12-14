//
//  THLPerkDetailWireframe.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkDetailModuleInterface.h"
@class THLEntityMapper;
@class THLPerkStoreItemEntity;
@protocol THLPerkItemStoreServiceInterface;

@interface THLPerkDetailWireframe : NSObject
@property (nonatomic, readonly, weak) id<THLPerkDetailModuleInterface> moduleInterface;
#pragma mark - Dependencies
@property (nonatomic, readonly, weak) id<THLPerkItemStoreServiceInterface> perkItemStoreService;
@property (nonatomic, readonly, weak) THLEntityMapper *entityMapper;
@property (nonatomic, readonly, weak) THLPerkStoreItemEntity *perkStoreItemEntity;
- (instancetype)initWithPerkItemStoreService:(id<THLPerkItemStoreServiceInterface>)perkItemStoreService
                                entityMapper:(THLEntityMapper *)entityMapper;
- (void)presentPerkDetailonViewController:(UIViewController *)viewController;
- (void)dismissInterface;
@end