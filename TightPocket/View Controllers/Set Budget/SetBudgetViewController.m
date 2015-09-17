//
//  SetBudgetViewController.m
//  TightPocket
//
//  Created by Peter Su on 16/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "SetBudgetViewController.h"
#import "BudgetValidator.h"

@interface SetBudgetViewController () <UIToolbarDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UISwitch *budgetSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dailyBudgetTitle;
@property (weak, nonatomic) IBOutlet UITextField *budgetTextField;

@end

@implementation SetBudgetViewController

- (void)initialise {
    [super initialise];
    [self initaliseToolBar];
    [self initialiseBudgetSwitch];
    [self initialiseDailyBudget];
}

- (void)initaliseToolBar {
    self.toolBar.delegate = self;
    UIImage *closeImage = [UIImage imageNamed:@"ic_close"];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(didPressCloseButton)];
    
    UIImage *saveImage = [UIImage imageNamed:@"ic_done"];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithImage:saveImage style:UIBarButtonItemStylePlain target:self action:@selector(didPressSaveButton)];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolBar.items = @[ closeButton, flexSpace, saveButton ];
}

- (void)initialiseBudgetSwitch {
    BOOL switchIsOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserSetBudget"];
    self.budgetSwitch.on = switchIsOn;
    [self setDailyBudgetHidden:!self.budgetSwitch.on];
    
    [self.budgetSwitch addTarget:self action:@selector(didChangeValueForSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (void)initialiseDailyBudget {
    self.budgetTextField.delegate = self;
    self.budgetTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    UILabel *currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    currencyLabel.textColor = [UIColor FNRDarkGrey];
    currencyLabel.text = @"£"; // TODO: Get currency symbol from locale
    currencyLabel.textAlignment = NSTextAlignmentCenter;
    [currencyLabel sizeToFit];
    CGRect spacedFrame = CGRectMake(0, 0, CGRectGetWidth(currencyLabel.frame) + 10, CGRectGetHeight(currencyLabel.frame));
    currencyLabel.frame = spacedFrame;
    
    [self.budgetTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.budgetTextField setLeftView:currencyLabel];
    
    UILabel *spacerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.budgetTextField setRightViewMode:UITextFieldViewModeAlways];
    [self.budgetTextField setRightView:spacerView];
    
    self.budgetTextField.layer.borderColor = [UIColor FNRDarkGrey].CGColor;
    self.budgetTextField.layer.borderWidth = 1.0f;
    self.budgetTextField.layer.cornerRadius = 4.0f;
    
    NSDecimalNumber *budget = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserBudget"];
    if (!budget || ![budget isKindOfClass:[NSNumber class]]) {
        self.budgetTextField.placeholder = @"0.00";
    } else {
        NSNumberFormatter *nf = [NSNumberFormatter new];
        [nf setNumberStyle:NSNumberFormatterCurrencyStyle];
        [nf setCurrencySymbol:@""];
        self.budgetTextField.text = [nf stringFromNumber:budget];
    }
}

#pragma mark - Actions / Selectors

- (void)setDailyBudgetHidden:(BOOL)hidden {
    self.dailyBudgetTitle.hidden = hidden;
    self.budgetTextField.hidden = hidden;
}

- (void)didPressCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressSaveButton {
    if (self.budgetSwitch.on) {
        NSDecimalNumber *budget;
        if ([self.budgetTextField.text isEqualToString:@""]) {
            budget = [NSDecimalNumber decimalNumberWithString:@"0.00"];
        } else {
            budget = [NSDecimalNumber decimalNumberWithString:self.budgetTextField.text];
        }
        [[NSUserDefaults standardUserDefaults] setObject:budget forKey:@"UserBudget"];
    }
    [[NSUserDefaults standardUserDefaults] setBool:self.budgetSwitch.on forKey:@"UserSetBudget"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didChangeValueForSwitch:(UISwitch *)aSwitch {
    if (aSwitch == self.budgetSwitch) {
        [self setDailyBudgetHidden:!aSwitch.on];
    }
}

#pragma mark - UIToolbarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.budgetTextField) {
        return [BudgetValidator validateTextFieldForAmount:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
