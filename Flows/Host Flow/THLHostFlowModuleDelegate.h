//
//  THLHostFlowModuleDelegate.h
//  TheHypelist
//
//  Created by Edgar Li on 11/18/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLHostFlowModuleInterface;
@protocol THLHostFlowModuleDelegate <NSObject>
- (void)logOutUser;
@end