//
//  THLDashboardTicketCellView.h
//  TheHypelist
//
//  Created by Edgar Li on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

@protocol THLDashboardTicketCellView <NSObject>
@property (nonatomic, copy) NSURL *locationImageURL;
@property (nonatomic, copy) NSURL *hostImageURL;
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventDate;
@property (nonatomic, copy) NSString *locationName;

@property (nonatomic) THLStatus guestlistReviewStatus;
@property (nonatomic, copy) NSString *guestlistReviewStatusTitle;
@end