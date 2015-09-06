//
//  NSDate+Extensions.m
//  TightPocket
//
//  Created by Peter Su on 02/09/2015.
//  Copyright © 2015 fenroar. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

+ (NSDate *)dayWithNoTime:(NSDate *)aDate {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                                   fromDate:aDate];
    NSDate *dayWithNoTime = [[NSCalendar currentCalendar]
                     dateFromComponents:components];
    
    return dayWithNoTime;
}

+ (NSDate *)today {
    return [NSDate dayWithNoTime:[NSDate date]];
}

+ (NSDate *)addNumberOfDays:(NSInteger)numberOfDay
                     toDate:(NSDate *)aDate {
    NSDate *yesterday = [aDate dateByAddingTimeInterval:86400 * (numberOfDay)];
    return yesterday;
}

+ (NSDate *)subtractNumberOfDays:(NSInteger)numberOfDay
                        fromDate:(NSDate *)aDate {
    NSDate *yesterday = [NSDate addNumberOfDays:(numberOfDay * -1)
                                         toDate:aDate];
    return yesterday;
}

- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *thisDateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    
    if (todayComponents.year == thisDateComponents.year &&
        todayComponents.month == thisDateComponents.month &&
        todayComponents.day == thisDateComponents.day) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isInFuture {
    return ([self compare:[NSDate date]] == NSOrderedAscending);
}

@end
