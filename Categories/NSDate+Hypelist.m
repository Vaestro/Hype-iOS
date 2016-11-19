//
//  NSDate+Hypelist.m
//  HypeList
//
//  Created by Phil Meyers IV on 8/8/15.
//  Copyright (c) 2015 HypeList. All rights reserved.
//

#import "NSDate+Hypelist.h"
#import "DateTools.h"
#import "NSDate+Utilities.h"

#define DAY_BREAK 4

@implementation NSDate (Hypelist)
+ (DTTimePeriod *)todayPeriod {
	return [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeDay startingAt:[self thl_today]];
}

+ (DTTimePeriod *)tomorrowPeriod {
	return [DTTimePeriod timePeriodWithSize:DTTimePeriodSizeDay startingAt:[self thl_tomorrow]];
}

- (DTTimePeriod *)momentPeriod {
	return [DTTimePeriod timePeriodWithStartDate:self endDate:self];
}

- (BOOL)thl_isOrAfterToday {
    return [self isLaterThan:[[NSDate date] dateByAddingTimeInterval:-60*300]];
}

+ (instancetype)thl_today {
	NSDate *date = [NSDate date];
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components: (NSCalendarUnit)NSUIntegerMax fromDate:date];
	if (components.hour < DAY_BREAK) {
		components.day -= 1;
	}
	components.hour = 4;
	components.minute = 0;
	components.second = 0
    ;

	NSDate *start = [calendar dateFromComponents:components];
	return start;
}

+ (instancetype)thl_tomorrow {
	return [[self thl_today] dateByAddingDays:1];
}

+ (instancetype)thl_nextWeek {
	return [[self thl_today] dateByAddingDays:7];
}

- (BOOL)thl_isToday {
	return [[self momentPeriod] isInside:[self.class todayPeriod]];
}

- (BOOL)thl_isTomorrow {
	return [[self momentPeriod] isInside:[self.class tomorrowPeriod]];
}

- (NSString *)thl_weekdayString {
	if ([self thl_isToday]) {
		return @"Today";
	} else if ([self thl_isTomorrow]) {
		return @"Tomorrow";
	} else {
		return [self formattedDateWithFormat:@"EEEE, MMMM d"];
	}
}


- (NSDate *)thl_sixHoursAhead {
    NSTimeInterval secondsInSixHours = 6 * 60 * 60;
    return [self dateByAddingTimeInterval:secondsInSixHours];
}

- (NSString *)thl_formattedDate {
    return [self formattedDateWithFormat:@"EEEE MMM, yyyy"];
}


- (NSString *)thl_dayString {
    return [self formattedDateWithFormat:@"d"];
}

- (NSString *)thl_dayOfTheWeek {
    return [self formattedDateWithFormat:@"EEEE"];
}

- (NSString *)thl_weekdayInitials {
    if ([[self formattedDateWithFormat:@"EEEE"] isEqualToString:@"Thursday"]) {
        return [self formattedDateWithFormat:@"EE"];
    } else if ([[self formattedDateWithFormat:@"EEEE"] isEqualToString:@"Sunday"]) {
        return [self formattedDateWithFormat:@"EE"];
    } else {
        return [self formattedDateWithFormat:@"E"];
    }
}

- (NSString *)thl_dateString {
	return [self mediumDateString];
}

- (NSString *)thl_longDateString {
    return [self longDateString];
}


- (NSString *)thl_timeString {
	return [self shortTimeString];
}

- (NSString *)thl_dateTimeString {
	return [self shortString];
}

- (NSString *)thl_endTimeString {
   
    return nil;
}



@end
