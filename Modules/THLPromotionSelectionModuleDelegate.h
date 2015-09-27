//
//  THLPromotionSelectionModuleDelegate.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLPromotionEntity;
@protocol THLPromotionSelectionModuleInterface;
@protocol THLPromotionSelectionModuleDelegate <NSObject>
- (void)promotionSelectionModule:(id<THLPromotionSelectionModuleInterface>)module didSelectPromotion:(THLPromotionEntity *)promotionEntity;
@end
