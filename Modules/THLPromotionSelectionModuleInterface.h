//
//  THLPromotionSelectionModuleInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPromotionSelectionModuleDelegate.h"

@class THLEventEntity;
@protocol THLPromotionSelectionModuleInterface <NSObject>
@property (nonatomic, weak) id<THLPromotionSelectionModuleDelegate> moduleDelegate;

- (void)presentPromotionSelectionInterfaceForEvent:(THLEventEntity *)eventEntity inViewController:(UIViewController *)controller;
@end
