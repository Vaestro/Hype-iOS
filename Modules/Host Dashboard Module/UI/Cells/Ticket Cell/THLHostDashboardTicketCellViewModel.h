//
//  THLHostDashboardTicketCellViewModel.h
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLHostDashboardTicketCellView.h"

@protocol THLHostDashboardTicketCellView;
@class THLGuestlistEntity;

@interface THLHostDashboardTicketCellViewModel : NSObject
@property (nonatomic, readonly) THLGuestlistEntity *guestlistEntity;

- (instancetype)initWithGuestlist:(THLGuestlistEntity *)guestlist;
- (void)configureView:(id<THLHostDashboardTicketCellView>)view;

@end
