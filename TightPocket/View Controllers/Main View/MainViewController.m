//
//  MainViewController.m
//  TightPocket
//
//  Created by Peter Su on 02/09/2015.
//  Copyright © 2015 fenroar. All rights reserved.
//

#import "MainViewController.h"
#import "AddExpenditureViewController.h"
#import "ExpenditureListViewController.h"
#import "NSDate+Extensions.h"
#import "Expenditure.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *previousDayButton;
@property (weak, nonatomic) IBOutlet UIButton *nextDayButton;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) NSDecimalNumber *totalBalance;

@property (weak, nonatomic) IBOutlet UIView *expendBarBackground;
@property (weak, nonatomic) IBOutlet UIView *expendBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expendBarWidth;

@property (strong, nonatomic) NSDate *currentDate;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLabels];
}

#pragma mark - UI

- (void)initialise {
    [super initialise];
    [self initialiseSwipeGesture];
    self.totalBalance = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    self.currentDate = [NSDate today];
    
    self.expendBarBackground.clipsToBounds = YES;
    self.expendBarBackground.layer.cornerRadius = 2.0f;
    self.expendBarBackground.layer.borderWidth = 1.0f;
    self.expendBarBackground.layer.borderColor = [UIColor FNRGrey].CGColor;
    
    // Date Buttons
    [self customiseButton:self.previousDayButton
                withImage:[UIImage imageNamed:@"ic_arrow_left"]];
    [self.previousDayButton addTarget:self action:@selector(prevDay) forControlEvents:UIControlEventTouchUpInside];
    
    [self customiseButton:self.nextDayButton
                withImage:[UIImage imageNamed:@"ic_arrow_right"]];
    [self.nextDayButton addTarget:self action:@selector(nextDay) forControlEvents:UIControlEventTouchUpInside];
    
    // Action Buttons
    [self.addButton addTarget:self action:@selector(didPressAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self.listButton addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self roundButton:self.addButton
            withImage:[UIImage imageNamed:@"ic_add"]];
    
    [self roundButton:self.listButton
            withImage:[UIImage imageNamed:@"ic_list"]];
}

- (void)customiseButton:(UIButton *)button
          withImage:(UIImage *)image {
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setImage:image
            forState:UIControlStateNormal];
}

- (void)roundButton:(UIButton *)button
          withImage:(UIImage *)image {
    [self customiseButton:button withImage:image];
    button.layer.cornerRadius = CGRectGetHeight(button.frame)/2;
    button.layer.borderColor = [UIColor FNRDarkGrey].CGColor;
    button.layer.borderWidth = 1.0f;
}

- (void)initialiseSwipeGesture {
    UISwipeGestureRecognizer *swipeRecognizerLeft = [UISwipeGestureRecognizer new];
    swipeRecognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [swipeRecognizerLeft addTarget:self action:@selector(didSwipe:)];
    [self.view addGestureRecognizer:swipeRecognizerLeft];
    
    UISwipeGestureRecognizer *swipeRecognizerRight = [UISwipeGestureRecognizer new];
    swipeRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
    [swipeRecognizerRight addTarget:self action:@selector(didSwipe:)];
    [self.view addGestureRecognizer:swipeRecognizerRight];
}

- (void)updateLabels {
    [self updateBalanceLabel];
    [self updateDateView];
}

- (void)updateBalanceLabel {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Expenditure"];
    
    NSDate *startOfDate = [NSDate dayWithNoTime:self.currentDate];
    NSDate *endOfDate = [NSDate addNumberOfDays:1 toDate:startOfDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(entryDate >= %@) && (entryDate < %@)", startOfDate, endOfDate];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    self.totalBalance = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    if (error) {
        NSLog(@"%@, %@", error, error.localizedDescription);
    } else {
        for (Expenditure *expenditure in result) {
            self.totalBalance = [self.totalBalance decimalNumberByAdding:expenditure.amount];
        }
        
        [self updateBalanceLimit:self.totalBalance];
    }
    
    NSNumberFormatter *currencyFormatter = [NSNumberFormatter new];
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.balanceLabel.text = [currencyFormatter stringFromNumber:self.totalBalance];
}

- (void)updateDateView {
    NSDate *lastMonthFromToday = [NSDate dayWithNoTime:[NSDate subtractNumberOfMonths:1
                                                                             fromDate:[NSDate date]]];
    self.addButton.hidden = ![self.currentDate isToday];
    self.nextDayButton.hidden = [self.currentDate isToday];
    self.previousDayButton.hidden = [self.currentDate compare:lastMonthFromToday] == NSOrderedSame;
    
    if ([self.currentDate isToday]) {
        self.dateLabel.text = @"Today";
        
    } else {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = kExpenditureDateFormat;
        self.dateLabel.text = [dateFormatter stringFromDate:self.currentDate];
    }
}

- (void)updateBalanceLimit:(NSDecimalNumber *)balance {
    if ([self userHasSetBudget] &&
        ([[self getBudget] compare:[NSDecimalNumber decimalNumberWithString:@"0.00"]]) == NSOrderedDescending) {
        self.expendBarBackground.hidden = NO;
        NSDecimalNumber *budget = [self getBudget];
        
        NSDecimalNumber *percentage;
        if ([balance compare:budget] == NSOrderedDescending) {
            percentage = [[budget decimalNumberByDividingBy:balance] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100.00"]];
            
            [self expendColorExceedBudget:YES];
        } else {
            percentage = [[balance decimalNumberByDividingBy:budget] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100.00"]];
            [self expendColorExceedBudget:NO];
        }
        self.expendBarWidth.constant = [percentage floatValue] * 2;
    } else {
        self.expendBarBackground.hidden = YES;
    }
}

- (BOOL)userHasSetBudget {
    // TODO: Check user defaults to see if user has set preference
    return YES;
}

- (NSDecimalNumber *)getBudget {
    // TODO: Should fetch budget from what user has set in core data
    return [NSDecimalNumber decimalNumberWithString:@"50.00"];
}

- (void)expendColorExceedBudget:(BOOL)exceeded {
    self.expendBarBackground.backgroundColor = (exceeded) ? [UIColor FNRRed] : [UIColor FNRGrey];
    self.expendBar.backgroundColor = [UIColor FNRGreen];
}

- (void)resetDate {
    self.currentDate = [NSDate today];
    [self updateLabels];
}

#pragma mark - Actions / Selectors

- (void)didSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            [self nextDay];
            break;
        case UISwipeGestureRecognizerDirectionRight: {
            [self prevDay];
        }
        default:
            break;
    }
}

- (void)didPressAddButton {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddExpenditureViewController *addExpenditureVC = [storyboard instantiateViewControllerWithIdentifier:@"AddExpenditureVC"];
    addExpenditureVC.managedObjectContext = self.managedObjectContext;
    [self presentViewController:addExpenditureVC animated:YES completion:nil];
}

- (void)didPressListButton {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExpenditureListViewController *expenditureListVC = [storyboard instantiateViewControllerWithIdentifier:@"ExpenditureListVC"];
    expenditureListVC.entryDate = self.currentDate;
    expenditureListVC.managedObjectContext = self.managedObjectContext;
    [self presentViewController:expenditureListVC animated:YES completion:nil];
}

- (void)nextDay {
    NSDate *nextDay = [NSDate addNumberOfDays:1
                                       toDate:self.currentDate];
    if ([nextDay isInFuture]) {
        self.currentDate = nextDay;
        [self updateLabels];
    }
}

- (void)prevDay {
    NSDate *prevDay = [NSDate subtractNumberOfDays:1
                                           fromDate:self.currentDate];
    
    NSDate *lastMonthFromToday = [NSDate dayWithNoTime:[NSDate subtractNumberOfMonths:1
                                                                             fromDate:[NSDate date]]];
    if ([prevDay compare:lastMonthFromToday] == NSOrderedDescending ||
        [prevDay compare:lastMonthFromToday] == NSOrderedSame) {
        self.currentDate = prevDay;
        [self updateLabels];
    }
    
}

@end
