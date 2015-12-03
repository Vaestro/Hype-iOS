//
//  THLHostDashboardNotificationCellView.h
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

@protocol THLHostDashboardNotificationCellView <NSObject>
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSURL *senderImageURL;
@property (nonatomic) THLStatus notificationStatus;
@property (nonatomic, copy) NSString *senderIntroductionText;
@end
