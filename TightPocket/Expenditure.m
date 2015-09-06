//
//  Expenditure.m
//  TightPocket
//
//  Created by Peter Su on 03/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "Expenditure.h"

@implementation Expenditure

NSString * const kCategoryFood = @"Food";
NSString * const kCategoryEntertainment = @"Entertainment";
NSString * const kCategoryTravel = @"Travel";
NSString * const kCategoryGroceries = @"Groceries";
NSString * const kCategoryMedical = @"Medical";
NSString * const kCategoryOther = @"Other";

NSString * const kExpenditureDateFormat = @"EEE, d MMM YYYY";

@dynamic amount;
@dynamic category;
@dynamic entryDate;
@dynamic notes;

- (NSString *)description {
    return [NSString stringWithFormat:@"Amount: %@\nCategory: %@\nEntry Date: %@\nNotes: %@",
            self.amount, self.category, self.entryDate, self.notes];
}

@end
