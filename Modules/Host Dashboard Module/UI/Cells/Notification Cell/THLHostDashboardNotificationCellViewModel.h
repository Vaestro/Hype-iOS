//
//  THLHostDashboardNotificationCellViewModel.h
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLHostDashboardNotificationCellView.h"

@protocol THLHostDashboardNotificationCellView;
@class THLGuestlistEntity;

@interface THLHostDashboardNotificationCellViewModel : NSObject
@property (nonatomic, readonly) THLGuestlistEntity *guestlistEntity;

- (instancetype)initWithGuestlist:(THLGuestlistEntity *)guestlist;
- (void)configureView:(id<THLHostDashboardNotificationCellView>)view;
@end
