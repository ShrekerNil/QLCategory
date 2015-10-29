//
//  NSDate+QLDate.m
//  EnjoyFishing
//
//  Created by Shrek on 15/1/25.
//  Copyright (c)2015年 Shrek. All rights reserved.
//

#import "NSDate+QLDate.h"
#import "NSDateFormatter+QLDateFormatter.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

NSUInteger const QLSecondsOfMinute = 60;
NSUInteger const QLSecondsOfHour = 3600;
NSUInteger const QLSecondsOfDay = 86400;
NSUInteger const QLSecondsOfWeek = 604800;
NSUInteger const QLSecondsOfYear = 31536000;

@implementation NSDate (QLDate)

/** 查询给定的日期月份对应的天数 */
+ (NSUInteger)daysInMonthFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return range.length;
}

/** 查询给定的日期月份对应的周数 */
+ (NSUInteger)weeksInMonthFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSWeekOfMonthCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return range.length;
}

/** 距离当前的时间间隔描述 */
- (NSString *)timeIntervalDescription {
    NSTimeInterval timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 60) {
        return @"1分钟内";
    } else if (timeInterval < QLSecondsOfHour) {
        return [NSString stringWithFormat:@"%.f分钟前", timeInterval / QLSecondsOfMinute];
    } else if (timeInterval < QLSecondsOfDay) {
        return [NSString stringWithFormat:@"%.f小时前", timeInterval / QLSecondsOfHour];
    } else if (timeInterval < 2592000) { //30天内
        return [NSString stringWithFormat:@"%.f天前", timeInterval / QLSecondsOfDay];
    } else if (timeInterval < QLSecondsOfYear) { //30天至1年内
        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"M月d日"];
        return [dateFormatter stringFromDate:self];
    } else {
        return [NSString stringWithFormat:@"%.f年前", timeInterval / QLSecondsOfYear];
    }
}

/** 精确到天的日期描述 */
- (NSString *)dayDescription {
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
    
    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    if ([theDay isEqualToString:currentDay]) { //当天
        [dateFormatter setDateFormat:@"ah:mm"];
        return [dateFormatter stringFromDate:self];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) { //昨天
        [dateFormatter setDateFormat:@"ah:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < 86400 * 7) { //间隔一周内
        [dateFormatter setDateFormat:@"EEEE ah:mm"];
        return [dateFormatter stringFromDate:self];
    } else { //以前
        [dateFormatter setDateFormat:@"yyyy-MM-dd ah:mm"];
        return [dateFormatter stringFromDate:self];
    }
}

/** 标准时间日期描述 */
-(NSString *)formattedTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString * dateNow = [formatter stringFromDate:[NSDate date]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(6,2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(4,2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0,4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:components]; //今天 0点时间
    
    NSInteger hour = [self hoursAfterDate:date];
    NSDateFormatter *dateFormatter = nil;
    
    //hasAMPM==TURE为12小时制，否则为24小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    
    if (hasAMPM) { //12小时制
        if (hour >= 0 && hour <= 6) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"凌晨hh:mm"];
        } else if (hour > 6 && hour <=11 ) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"上午hh:mm"];
        } else if (hour > 11 && hour <= 17) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"下午hh:mm"];
        } else if (hour > 17 && hour <= 24) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"晚上hh:mm"];
        } else if (hour < 0 && hour >= -24) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天HH:mm"];
        } else {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
        }
    } else { //24小时制
        if (hour <= 24 && hour >= 0) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"HH:mm"];
        } else if (hour < 0 && hour >= -24) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天HH:mm"];
        } else {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
        }
    }
    
    return [dateFormatter stringFromDate:self];
}


/** 格式化日期描述 */
- (NSString *)formattedDateDescription {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSInteger timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 60) {
        return @"1分钟内";
    } else if (timeInterval < 3600) { //1小时内
        return [NSString stringWithFormat:@"%ld分钟前", timeInterval / 60];
    } else if (timeInterval < 21600) { //6小时内
        return [NSString stringWithFormat:@"%ld小时前", timeInterval / 3600];
    } else if ([theDay isEqualToString:currentDay]) { //当天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:self]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) { //昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
    } else { //以前
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:self];
    }
}

- (NSTimeInterval)timeIntervalSince1970InMilliSecond {
    return [self timeIntervalSince1970] * 1000;
}

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    double timeInterval = timeIntervalInMilliSecond;
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (NSString *)formattedTimeFromTimeInterval:(long long)time {
    return [[NSDate dateWithTimeIntervalInMilliSecondSince1970:time] formattedTime];
}

#pragma mark Relative Dates

+ (NSDate *)dateWithDaysFromNow:(NSInteger)days {
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days {
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *)dateTomorrow {
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateYesterday {
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + QLSecondsOfHour * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - QLSecondsOfHour * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + QLSecondsOfMinute * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - QLSecondsOfMinute * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark Comparing Dates

- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year)&&
            (components1.month == components2.month)&&
            (components1.day == components2.day));
}

- (BOOL)isToday {
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow {
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL)isYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL)isSameWeekAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    if (components1.week != components2.week)return NO;
    
    // Must have a time interval under 1 week. Thanks @aclark
    return (fabs([self timeIntervalSinceDate:aDate]) < QLSecondsOfWeek);
}

- (BOOL)isThisWeek {
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + QLSecondsOfWeek;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isLastWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - QLSecondsOfWeek;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL)isSameMonthAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
    return ((components1.month == components2.month)&&
            (components1.year == components2.year));
}

- (BOOL)isThisMonth {
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL)isSameYearAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL)isThisYear {
    // Thanks, baspellis
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL)isNextYear {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL)isLastYear {
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL)isEarlierThanDate:(NSDate *)aDate {
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThanDate:(NSDate *)aDate {
    return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL)isInFuture {
    return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL)isInPast {
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark Roles
- (BOOL)isTypicallyWeekend {
    NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
    if ((components.weekday == 1) || (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL)isTypicallyWorkday {
    return ![self isTypicallyWeekend];
}

#pragma mark Adjusting Dates
- (NSDate *)dateByAddingDays:(NSInteger)dDays {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + QLSecondsOfDay * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingDays:(NSInteger)dDays {
    return [self dateByAddingDays:(dDays * -1)];
}

- (NSDate *)dateByAddingHours:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + QLSecondsOfHour * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingHours:(NSInteger)dHours {
    return [self dateByAddingHours:(dHours * -1)];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + QLSecondsOfMinute * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes {
    return [self dateByAddingMinutes:(dMinutes * -1)];
}

- (NSDate *)dateAtStartOfDay {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate {
    NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger)minutesAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / QLSecondsOfMinute);
}

- (NSInteger)minutesBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / QLSecondsOfMinute);
}

- (NSInteger)hoursAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / QLSecondsOfHour);
}

- (NSInteger)hoursBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / QLSecondsOfHour);
}

- (NSInteger)daysAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / QLSecondsOfDay);
}

- (NSInteger)daysBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / QLSecondsOfDay);
}

- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark Decomposing Dates

- (NSInteger)nearestHour {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + QLSecondsOfMinute * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
    return components.hour;
}

- (NSInteger)hour {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

- (NSInteger)minute {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

- (NSInteger)seconds {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

- (NSInteger)day {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}

- (NSInteger)month {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}

- (NSInteger)week {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.week;
}

- (NSInteger)weekday {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}

- (NSInteger)nthWeekday  { // e.g. 2nd Tuesday of the month is 2
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger)year {
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}

@end
