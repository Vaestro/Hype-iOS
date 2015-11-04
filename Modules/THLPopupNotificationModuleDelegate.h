//
//  THLPopupNotificationModuleInterface.h
//  Hypelist2point0
//
//  Created by Edgar Li on 11/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class THLEventEntity;

@protocol THLPopupNotificationModuleInterface;
@protocol THLPopupNotificationModuleDelegate <NSObject>
- (void)popupNotificationModule:(id<THLPopupNotificationModuleInterface>)module userDidAcceptReviewForEvent:(THLEventEntity *)eventEntity;
@end
