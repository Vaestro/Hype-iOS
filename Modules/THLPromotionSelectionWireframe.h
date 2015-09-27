//
//  THLPromotionSelectionWireframe.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPromotionSelectionModuleInterface.h"
@class THLEntityMapper;
@protocol THLPromotionServiceInterface;

@interface THLPromotionSelectionWireframe : NSObject
@property (nonatomic, readonly) id<THLPromotionSelectionModuleInterface> moduleInterface;

@property (nonatomic, readonly) THLEntityMapper *entityMapper;
@property (nonatomic, readonly) id<THLPromotionServiceInterface> promotionService;

- (instancetype)initWithEntityMapper:(THLEntityMapper *)entityMapper
					promotionService:(id<THLPromotionServiceInterface>)promotionService;

- (void)presentInterfaceInViewController:(UIViewController *)controller;
- (void)dismissInterface;
@end
