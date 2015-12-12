//
//  THLPerkDetailModuleDelegate.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/6/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLPerkStoreItemEntity;

@protocol THLPerkDetailModuleInterface;
@protocol THLPerkDetailModuleDelegate <NSObject>
- (void)dismissPerkDetailWireframe;
@end
