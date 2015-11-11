//
//  THLUserProfileWireframe.h
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLUserProfileModuleInterface.h"

@interface THLUserProfileWireframe : NSObject
@property (nonatomic, readonly) id<THLUserProfileModuleInterface> moduleInterface;

- (void)presentInterfaceInViewController:(UIViewController *)viewController;
@end
