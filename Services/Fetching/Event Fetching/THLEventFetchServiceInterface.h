//
//  THLEventFetchServiceInterface.h
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/22/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFTask;

@protocol THLEventFetchServiceInterface <NSObject>
- (BFTask *)fetchEventsStartingOn:(NSDate *)startDate endingOn:(NSDate *)endDate;
@end
