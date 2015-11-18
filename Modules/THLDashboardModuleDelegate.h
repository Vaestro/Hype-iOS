//
//  THLDashboardModuleDelegate.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

@protocol THLDashboardModuleInterface;
@class THLEventEntity;
@protocol THLDashboardModuleDelegate <NSObject>
- (void)dashboardModule:(id<THLDashboardModuleInterface>)module didClickToViewEvent:(THLEventEntity *)event;
@end