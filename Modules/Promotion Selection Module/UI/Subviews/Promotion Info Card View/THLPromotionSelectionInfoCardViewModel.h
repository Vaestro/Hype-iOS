//
//  THLPromotionSelectionInfoCardViewModel.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLPromotionSelectionInfoCardViewModel : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *guestlistSpace;
@property (nonatomic, copy, readonly) NSDate *arrivalTime;
@property (nonatomic, readonly) float rating;
@property (nonatomic, readonly) float coverCharge;
@property (nonatomic, readonly) int maleRatio;
@property (nonatomic, readonly) int femaleRatio;
@end
