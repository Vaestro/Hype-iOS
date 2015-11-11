//
//  THLUserProfileModuleInterface.h
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLUserProfileModuleDelegate.h"

@protocol THLUserProfileModuleInterface <NSObject>
@property (nonatomic, weak) id<THLUserProfileModuleDelegate> moduleDelegate;

- (void)presentUserProfileInterfaceInViewController:(UIViewController *)viewController;
@end