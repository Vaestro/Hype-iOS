//
//  THLEventTicketPromotionView.h
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLEventTicketPromotionView : UIView
@property (nonatomic) THLStatus guestlistReviewStatus;
@property (nonatomic, copy) NSString *guestlistReviewStatusTitle;
@property (nonatomic, copy) NSURL *hostImageURL;
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) NSString *eventTime;
@end
