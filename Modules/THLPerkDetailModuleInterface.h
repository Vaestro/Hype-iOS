//
//  THLPerkDetailModuleInterface.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkDetailModuleDelegate.h"
@class THLPerkStoreItemEntity;

@protocol THLPerkDetailModuleInterface <NSObject>
@property (nonatomic, weak) id<THLPerkDetailModuleDelegate> moduleDelegate;
- (void)presentPerkDetailInterfaceForPerk:(THLPerkStoreItemEntity *)perkEntity onViewController:(UIViewController *)viewController;
@end
