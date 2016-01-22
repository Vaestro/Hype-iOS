//
//  THLPerkStoreModuleInterface.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "THLPerkStoreModuleDelegate.h"

@protocol THLPerkStoreModuleInterface <NSObject>
@property (nonatomic, weak) id<THLPerkStoreModuleDelegate> moduleDelegate;

- (void)presentPerkStoreInterfaceInNavigationController:(UINavigationController *)navigationController;
@end
