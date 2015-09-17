//
//  StatsViewController.m
//  TightPocket
//
//  Created by Peter Su on 17/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "StatsViewController.h"
#import "Expenditure.h"

@interface StatsViewController ()

@property (strong, nonatomic) NSMutableDictionary *categorisedSpendings;
@property (strong, nonatomic) NSDecimalNumber *totalExpenseThisMonth;

@end

@implementation StatsViewController- (void)initialise {
    [super initialise];
    
    NSDate *startOfThisMonth = [NSDate startOfThisMonth];
    NSLog(@"startOfThisMonth");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Expenditure"];
    
    NSDate *startOfDate = [NSDate dayWithNoTime:startOfThisMonth];
    NSDate *endOfDate = [NSDate addNumberOfDays:1 toDate:[NSDate dayWithNoTime:[NSDate startOfToday]]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(entryDate >= %@) && (entryDate < %@)", startOfDate, endOfDate];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *allExpenditures = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    self.totalExpenseThisMonth = [self calculateTotalExpense:allExpenditures];
    NSLog(@"Total expense this month: %@", self.totalExpenseThisMonth);
    
    NSArray *categories = @[ kCategoryFood, kCategoryEntertainment, kCategoryGroceries, kCategoryMedical, kCategoryTravel, kCategoryOther ];
    for (NSString *category in categories) {
        NSDecimalNumber *totalCategoryExpenses = [self calculateTotalExpense:allExpenditures forCategory:category];
        NSLog(@"%@ expense: %@", category, totalCategoryExpenses);
    }
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (NSDecimalNumber *)calculateTotalExpense:(NSArray *)expendituresArray {
    NSDecimalNumber *totalExpense = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    for (Expenditure *expenditure in expendituresArray) {
        totalExpense = [totalExpense decimalNumberByAdding:expenditure.amount];
    }
    return totalExpense;
}

- (NSDecimalNumber *)calculateTotalExpense:(NSArray *)expendituresArray forCategory:(NSString *)category {
    NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"category == %@", category];
    NSArray *categoryExpenses = [expendituresArray filteredArrayUsingPredicate:categoryPredicate];
    
    return [self calculateTotalExpense:categoryExpenses];
}


@end
