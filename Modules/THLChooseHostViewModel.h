//
//  THLChooseHostViewModel.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THLChooseHostViewModel : NSObject
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *guestlistSpace;
@property (nonatomic, copy, readonly) NSDate *arrivalTime;
@property (nonatomic, copy, readonly) UIImage *thumbnail;
@property (nonatomic, readonly) float rating;
@property (nonatomic, readonly) float coverCharge;
@property (nonatomic, readonly) int maleRatio;
@property (nonatomic, readonly) int femaleRatio;
@end
