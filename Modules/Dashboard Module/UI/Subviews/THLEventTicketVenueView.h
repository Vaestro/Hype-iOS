//
//  THLNightTicketVenueView.h
//  HypeList
//
//  Created by Phil Meyers IV on 8/1/15.
//  Copyright (c) 2015 HypeList. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THLEventTicketVenueView : UIView
@property (nonatomic, copy) NSURL *locationImageURL;
@property (nonatomic, copy) NSURL *locationName;
@property (nonatomic) THLStatus guestlistReviewStatus;
@property (nonatomic, copy) NSString *guestlistReviewStatusTitle;
@property (nonatomic, copy) NSString *eventTime;

- (void)setGradientLayer;
@end
