//
//  THLPopupNotificationModuleInterface.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPopupNotificationModuleDelegate.h"

@protocol THLPopupNotificationModuleInterface <NSObject>
@property (nonatomic, weak) id<THLPopupNotificationModuleDelegate> moduleDelegate;

- (BFTask *)presentPopupNotificationModuleInterfaceWithPushInfo:(NSDictionary *)pushInfo;
@end
