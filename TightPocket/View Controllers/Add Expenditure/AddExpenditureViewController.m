//
//  AddExpenditureViewController.m
//  TightPocket
//
//  Created by Peter Su on 02/09/2015.
//  Copyright © 2015 fenroar. All rights reserved.
//

#import "AddExpenditureViewController.h"
#import "ExpenditureCategoryViewController.h"
#import "BudgetValidator.h"
#import "Expenditure.h"

@interface AddExpenditureViewController () <UIToolbarDelegate, UITextFieldDelegate, ExpenditureCategoryDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@end

@implementation AddExpenditureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.entryDate == nil) {
        self.entryDate = [NSDate date];
    }
}

- (void)initialise {
    [super initialise];
    [self initaliseToolBar];
    
    [self initialiseTextField:self.amountTextField placeholder:@"Amount (£)"];
    self.amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self initialiseTextField:self.categoryTextField placeholder:@"Category"];
    
    [self initialiseTextField:self.notesTextField placeholder:@"Notes"];
    
    [self.addButton addTarget:self action:@selector(didPressAddButton) forControlEvents:UIControlEventTouchUpInside];
   
    UIImage *buttonImage = [UIImage imageNamed:@"ic_done"];
    self.addButton.tintColor = [UIColor FNRRed];
    [self.addButton setTitle:@"" forState:UIControlStateNormal];
    [self.addButton setImage:buttonImage
            forState:UIControlStateNormal];
    self.addButton.layer.cornerRadius = CGRectGetHeight(self.addButton.frame)/2;
    self.addButton.layer.borderColor = [UIColor FNRDarkGrey].CGColor;
    self.addButton.layer.borderWidth = 1.0f;
}

- (void)initaliseToolBar {
    self.toolBar.delegate = self;
    UIImage *closeImage = [UIImage imageNamed:@"ic_close"];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(didPressCloseButton)];
    
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"Add Expenditure";
    [self.view addSubview:label];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.toolBar attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.toolBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    self.toolBar.items = @[ closeButton ];
}

- (void)initialiseTextField:(UITextField *)textField placeholder:(NSString *)placeholder {
    textField.delegate = self;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    [textField setLeftView:spacerView];
    
    [textField setRightViewMode:UITextFieldViewModeAlways];
    [textField setRightView:spacerView];
    
    textField.placeholder = placeholder;
    textField.layer.borderColor = [UIColor FNRDarkGrey].CGColor;
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 4.0f;
}

#pragma mark - Actions / Selectors

- (void)didPressCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didPressAddButton {
    NSString *amount = self.amountTextField.text;
    NSString *category = self.categoryTextField.text;
    NSString *notes = self.notesTextField.text;

    if (![amount isEqualToString:@""] &&
        ![category isEqualToString:@""]) {
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Expenditure" inManagedObjectContext:self.managedObjectContext];
        
        Expenditure *newExpenditure = [[Expenditure alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        newExpenditure.amount = [NSDecimalNumber decimalNumberWithString:amount];
        newExpenditure.category = category;
        newExpenditure.notes = notes;
        newExpenditure.entryDate = self.entryDate;
        
        NSError *error = nil;
        [newExpenditure.managedObjectContext save:&error];
        
        if (error) {
            NSLog(@"Error saving: %@", error.localizedDescription);
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        NSString *alertMessage = @"Unexpected error";
        if ([amount isEqualToString:@""]) {
            alertMessage = @"Amount not entered";
        } else if ([category isEqualToString:@""]) {
            alertMessage = @"Select a Category";
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                 message:alertMessage
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:closeAction];
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (textField == self.categoryTextField) {
        ExpenditureCategoryViewController *categoryVC = [storyboard instantiateViewControllerWithIdentifier:@"ExpenditureCategoryVC"];
        categoryVC.delegate = self;
        [self presentViewController:categoryVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.amountTextField) {
        return [BudgetValidator validateTextFieldForAmount:self.amountTextField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ExpenditureCategoryDelegate

- (void)didSelectCategory:(NSString *)category {
    self.categoryTextField.text = category;
}

#pragma UIToolbarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
