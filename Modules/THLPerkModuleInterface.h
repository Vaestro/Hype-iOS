//
//  THLPerkModuleInterface.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "THLPerkModuleDelegate.h"

@protocol THLPerkModuleInterface <NSObject>
@property (nonatomic, weak) id<THLPerkModuleDelegate> moduleDelegate;

-(void)presentPerkInterfaceInWindow:(UIWindow *)window;
@end
