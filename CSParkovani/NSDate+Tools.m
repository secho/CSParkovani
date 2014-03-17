//
//  NSDate+Tools.m
//  CSParkovani
//
//  Created by Viktor Smidl on 14/03/14.
//  Copyright (c) 2014 csas. All rights reserved.
//

#import "NSDate+Tools.h"

@implementation NSDate (Tools)

- (NSDate *)midnightDate
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateWithDayOffset:(NSInteger)dayOffset
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = dayOffset;
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSString *)toStringWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [NSDateFormatter new];

    formatter.dateFormat = dateFormat;
    
    return [formatter stringFromDate:self];
}

- (NSDate *)firstDayOfTheWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate:self];
    [components setWeek:[components week]];
    [components setWeekday:2]; // 1 == Sunday, 7 == Saturday
    
    return [calendar dateFromComponents:components];
}

- (NSInteger)dayOfWeek
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit fromDate:self];
    
    return ([components weekday] + 5) % 7;  // 0 == Monday, 6 == Sunday
}

@end
