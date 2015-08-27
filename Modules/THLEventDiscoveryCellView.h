//
//  THLEventDiscoveryCellView.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol THLEventDiscoveryCellView <NSObject>
@property (nonatomic, copy) NSString *locationName;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *locationNeighborhood;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSURL *imageURL;
@end
