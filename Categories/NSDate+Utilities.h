/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (Utilities)
+ (NSCalendar *) currentCalendar; // avoid bottlenecks

// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Short string utilities
- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
- (NSString *) stringWithFormat: (NSString *) format;
@property (nonatomic, readonly) NSString *shortString;
@property (nonatomic, readonly) NSString *shortDateString;
@property (nonatomic, readonly) NSString *shortTimeString;
@property (nonatomic, readonly) NSString *mediumString;
@property (nonatomic, readonly) NSString *mediumDateString;
@property (nonatomic, readonly) NSString *mediumTimeString;
@property (nonatomic, readonly) NSString *longString;
@property (nonatomic, readonly) NSString *longDateString;
@property (nonatomic, readonly) NSString *longTimeString;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;

@property (NS_NONATOMIC_IOSONLY, getter=isToday, readonly) BOOL today;
@property (NS_NONATOMIC_IOSONLY, getter=isTomorrow, readonly) BOOL tomorrow;
@property (NS_NONATOMIC_IOSONLY, getter=isYesterday, readonly) BOOL yesterday;

- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
@property (NS_NONATOMIC_IOSONLY, getter=isThisWeek, readonly) BOOL thisWeek;
@property (NS_NONATOMIC_IOSONLY, getter=isNextWeek, readonly) BOOL nextWeek;
@property (NS_NONATOMIC_IOSONLY, getter=isLastWeek, readonly) BOOL lastWeek;

- (BOOL) isSameMonthAsDate: (NSDate *) aDate;
@property (NS_NONATOMIC_IOSONLY, getter=isThisMonth, readonly) BOOL thisMonth;
@property (NS_NONATOMIC_IOSONLY, getter=isNextMonth, readonly) BOOL nextMonth;
@property (NS_NONATOMIC_IOSONLY, getter=isLastMonth, readonly) BOOL lastMonth;

- (BOOL) isSameYearAsDate: (NSDate *) aDate;
@property (NS_NONATOMIC_IOSONLY, getter=isThisYear, readonly) BOOL thisYear;
@property (NS_NONATOMIC_IOSONLY, getter=isNextYear, readonly) BOOL nextYear;
@property (NS_NONATOMIC_IOSONLY, getter=isLastYear, readonly) BOOL lastYear;

- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;

@property (NS_NONATOMIC_IOSONLY, getter=isInFuture, readonly) BOOL inFuture;
@property (NS_NONATOMIC_IOSONLY, getter=isInPast, readonly) BOOL inPast;

// Date roles
@property (NS_NONATOMIC_IOSONLY, getter=isTypicallyWorkday, readonly) BOOL typicallyWorkday;
@property (NS_NONATOMIC_IOSONLY, getter=isTypicallyWeekend, readonly) BOOL typicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingYears: (NSInteger) dYears;
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;

// Date extremes
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDate *dateAtStartOfDay;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDate *dateAtEndOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;
@end
