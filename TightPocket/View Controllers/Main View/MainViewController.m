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

@interface MainViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) CGFloat lastContentOffset;

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) NSDecimalNumber *totalBalance;

@property (strong, nonatomic) NSDate *currentDate;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLabels];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0) animated:NO];
}

#pragma mark - UI

- (void)initialise {
    [super initialise];
    
    self.totalBalance = [NSDecimalNumber decimalNumberWithString:@"12345.00"];
    
    self.currentDate = [NSDate today];
    
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    [self.addButton addTarget:self action:@selector(didPressAddButton) forControlEvents:UIControlEventTouchUpInside];
    [self.listButton addTarget:self action:@selector(didPressListButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self roundButton:self.addButton
            withImage:[UIImage imageNamed:@"ic_add"]
            withColor:[UIColor redColor]];
    
    [self roundButton:self.listButton
            withImage:[UIImage imageNamed:@"ic_list"]
            withColor:[UIColor blueColor]];
}

- (void)roundButton:(UIButton *)button
          withImage:(UIImage *)image
          withColor:(UIColor *)backgroundColor {
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setImage:image
                    forState:UIControlStateNormal];
    button.layer.cornerRadius = CGRectGetHeight(button.frame)/2;
    button.backgroundColor = backgroundColor;
}

- (void)updateLabels {
    [self updateBalanceLabel];
    [self updateDateLabel];
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
    }
    
    NSNumberFormatter *currencyFormatter = [NSNumberFormatter new];
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.balanceLabel.text = [currencyFormatter stringFromNumber:self.totalBalance];
}

- (void)updateDateLabel {
    self.addButton.hidden = ![self.currentDate isToday];
    if ([self.currentDate isToday]) {
        self.dateLabel.text = @"Today";
        
    } else {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = kExpenditureDateFormat;
        self.dateLabel.text = [dateFormatter stringFromDate:self.currentDate];
    }
}

#pragma mark - Actions / Selectors

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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint originPoint = CGPointMake(CGRectGetWidth(self.view.frame), 0);
    if (!CGPointEqualToPoint(self.scrollView.contentOffset, originPoint)) {
        if (self.lastContentOffset < (int)scrollView.contentOffset.x) {
            NSLog(@"right");
            NSDate *nextDay = [NSDate addNumberOfDays:1
                                               toDate:self.currentDate];
            if ([nextDay isInFuture]) {
                self.currentDate = [NSDate addNumberOfDays:1
                                                    toDate:self.currentDate];
                [self updateLabels];
            }
        }
        else if (self.lastContentOffset > (int)scrollView.contentOffset.x) {
            NSLog(@"left");
            self.currentDate = [NSDate subtractNumberOfDays:1
                                                   fromDate:self.currentDate];
            [self updateLabels];
        }

        [self.scrollView setContentOffset:originPoint
                                 animated:NO];
    }
}

- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"didEndDragging");
    
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    });
}

- (void)scrollViewDidEndScrollingAnimation:(nonnull UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation");
//    NSLog(@"offset: %@", NSStringFromCGPoint(scrollView.contentOffset));
}

@end
