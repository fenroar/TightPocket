//
//  NSDate+Extensions.h
//  TightPocket
//
//  Created by Peter Su on 02/09/2015.
//  Copyright © 2015 fenroar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

+ (NSDate *)dayWithNoTime:(NSDate *)aDate;
+ (NSDate *)today;
+ (NSDate *)subtractNumberOfMonths:(NSInteger)months
                          fromDate:(NSDate *)aDate;
+ (NSDate *)addNumberOfDays:(NSInteger)numberOfDay
                     toDate:(NSDate *)aDate;
+ (NSDate *)subtractNumberOfDays:(NSInteger)numberOfDay
                        fromDate:(NSDate *)aDate;

- (BOOL)isToday;
- (BOOL)isInFuture;
- (BOOL)isInPast;

@end
