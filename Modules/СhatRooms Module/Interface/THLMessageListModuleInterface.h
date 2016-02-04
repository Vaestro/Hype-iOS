//
//  THLMessageListModuleInterface.h
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLMessageListModuleDelegate.h"

@protocol THLMessageListModuleInterface <NSObject>
@property (nonatomic, weak) id<THLMessageListModuleDelegate> moduleDelegate;
- (void)presentEventDiscoveryInterfaceInNavigationController:(UINavigationController *)navigationController;
@end
