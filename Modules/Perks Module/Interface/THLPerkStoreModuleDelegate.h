//
//  THLPerkStoreModuleDelegate.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLPerkStoreItemEntity;
@protocol THLPerkStoreModuleInterface;


@protocol THLPerkStoreModuleDelegate <NSObject>
- (void)perkModule:(id<THLPerkStoreModuleInterface>)module userDidSelectPerkStoreItemEntity:(THLPerkStoreItemEntity *)perkStoreItemEntity presentPerkDetailInterfaceOnController:(UIViewController *)controller;
- (void)dismissPerkWireframe;
@end
