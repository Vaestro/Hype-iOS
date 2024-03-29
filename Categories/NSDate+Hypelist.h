//
//  NSDate+Hypelist.h
//  HypeList
//
//  Created by Phil Meyers IV on 8/8/15.
//  Copyright (c) 2015 HypeList. All rights reserved.
//


@interface NSDate (Hypelist)
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL thl_isToday;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL thl_isTomorrow;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *thl_weekdayString;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *thl_dateString;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *thl_monthDateString;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *thl_longDateString;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *thl_timeString;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *thl_dateTimeString;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *thl_dayString;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *thl_endTimeString;
+ (instancetype)thl_today;
+ (instancetype)thl_tomorrow;
+ (instancetype)thl_nextWeek;
- (BOOL)thl_isOrAfterToday;
- (NSString *)thl_dayOfTheWeek;
- (NSString *)thl_weekdayInitials;

- (NSDate *)thl_sixHoursAhead;
- (NSString *)thl_formattedDate;
@end
