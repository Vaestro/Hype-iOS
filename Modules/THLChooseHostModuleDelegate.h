//
//  THLChooseHostModuleDelegate.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class THLPromotion;
@protocol THLChooseHostModuleInterface;
@protocol THLChooseHostModuleDelegate <NSObject>
- (void)chooseHostModule:(id<THLChooseHostModuleInterface>)module didSelectHost:(THLPromotion *)promotion;
@end
