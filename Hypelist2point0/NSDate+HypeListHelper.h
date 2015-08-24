//
//  NSDate+HypeListHelper.h
//  HypeList
//
//  Created by Phil Meyers IV on 8/8/15.
//  Copyright (c) 2015 HypeList. All rights reserved.
//


@interface NSDate (HypeListHelper)
- (BOOL)thl_isToday;
- (BOOL)thl_isTomorrow;
+ (instancetype)thl_today;
+ (instancetype)thl_tomorrow;
+ (instancetype)thl_nextWeek;
- (NSString *)thl_weekdayString;
- (NSString *)thl_dateString;
- (NSString *)thl_timeString;
- (NSString *)thl_dateTimeString;
@end
