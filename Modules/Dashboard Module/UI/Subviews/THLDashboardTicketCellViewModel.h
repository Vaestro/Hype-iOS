//
//  THLDashboardTicketCellViewModel.h
//  TheHypelist
//
//  Created by Edgar Li on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLDashboardTicketCellView.h"

@protocol THLDashboardTicketCellView;
@class THLGuestlistInviteEntity;

@interface THLDashboardTicketCellViewModel : NSObject
@property (nonatomic, readonly) THLGuestlistInviteEntity *guestlistInviteEntity;

- (instancetype)initWithGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInvite;
- (void)configureView:(id<THLDashboardTicketCellView>)view;

@end
