//
//  BudgetValidator.h
//  TightPocket
//
//  Created by Peter Su on 17/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BudgetValidator : NSObject

+ (BOOL)validateTextFieldForAmount:(UITextField *)textField
     shouldChangeCharactersInRange:(NSRange)range
                 replacementString:(NSString *)string;

@end
