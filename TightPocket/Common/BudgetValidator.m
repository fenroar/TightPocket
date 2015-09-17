//
//  BudgetValidator.m
//  TightPocket
//
//  Created by Peter Su on 17/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "BudgetValidator.h"

@implementation BudgetValidator

+ (BOOL)validateTextFieldForAmount:(UITextField *)textField
     shouldChangeCharactersInRange:(NSRange)range
                 replacementString:(NSString *)string {
    static NSString *numbers = @"0123456789";
    static NSString *numbersPeriod = @"01234567890.";
    static NSString *numbersComma = @"0123456789,";
    
    if (range.length > 0 && [string length] == 0) {
        // enable delete
        return YES;
    }
    
    NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    if (range.location == 0 && [string isEqualToString:symbol]) {
        // decimalseparator should not be first
        return NO;
    }
    NSCharacterSet *characterSet;
    NSRange separatorRange = [textField.text rangeOfString:symbol];
    if (separatorRange.location == NSNotFound) {
        if ([symbol isEqualToString:@"."]) {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersPeriod] invertedSet];
        }
        else {
            characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersComma] invertedSet];
        }
    }
    else {
        // allow 2 characters after the decimal separator
        if (range.location > (separatorRange.location + 2)) {
            return NO;
        }
        characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
    }
    return ([[string stringByTrimmingCharactersInSet:characterSet] length] > 0);
}

@end
