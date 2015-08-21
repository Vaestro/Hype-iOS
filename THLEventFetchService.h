//
//  THLEventFetchService.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

@interface THLEventFetchService : NSObject
+ (BFTask *)fetchEventsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate;
@end
