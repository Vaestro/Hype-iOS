//
//  THLDashboardNotificationCellViewModel.h
//  TheHypelist
//
//  Created by Edgar Li on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLDashboardNotificationCellView.h"

@protocol THLDashboardNotificationCellView;
@class THLGuestlistInviteEntity;

@interface THLDashboardNotificationCellViewModel : NSObject
@property (nonatomic, readonly) THLGuestlistInviteEntity *guestlistInviteEntity;

- (instancetype)initWithGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite;
- (void)configureView:(id<THLDashboardNotificationCellView>)view;
@end
