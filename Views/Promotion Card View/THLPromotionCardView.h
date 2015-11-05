//
//  THLPromotionCardView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THLPromotionCardView : UIView
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, copy) UIImage *hostThumbnail;
@property (nonatomic, copy) NSDate *arrivalTime;
@property (nonatomic, copy) NSString *guestlistSpace;
@property (nonatomic) float hostRating;
@property (nonatomic) int coverCharge;
@property (nonatomic) int femaleRatio;
@end
