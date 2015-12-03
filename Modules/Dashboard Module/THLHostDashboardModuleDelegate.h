//
//  THLHostDashboardModuleDelegate.h
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

@protocol THLHostDashboardModuleInterface;
@class THLGuestlistEntity;
@protocol THLHostDashboardModuleDelegate <NSObject>
- (void)hostDashboardModule:(id<THLHostDashboardModuleInterface>)module didClickToViewGuestlistReqeust:(THLGuestlistEntity *)guestlist;
@end