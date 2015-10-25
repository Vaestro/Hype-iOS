//
//  THLEventDetailModuleDelegate.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLPromotionEntity;

@protocol THLEventDetailModuleInterface;
@protocol THLEventDetailModuleDelegate <NSObject>
- (void)eventDetailModule:(id<THLEventDetailModuleInterface>)module promotion:(THLPromotionEntity *)promotionEntity;
@end
