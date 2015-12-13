//
//  THLUserProfileModuleDelegate.h
//  TheHypelist
//
//  Created by Edgar Li on 11/10/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLUserProfileModuleInterface;
@protocol THLUserProfileModuleDelegate <NSObject>
- (void)logOutUser;
- (void)presentPerkInterfaceInWindow;
@end