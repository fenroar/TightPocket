//
//  ExpenditureListViewController.m
//  TightPocket
//
//  Created by Peter Su on 04/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "ExpenditureListViewController.h"
#import "ExpenditureTableCell.h"
#import "Expenditure.h"
#import "NSDate+Extensions.h"

@interface ExpenditureListViewController () <UIToolbarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *expenditures;

@end

static NSString * const ExpenditureCellIdentifier = @"ExpenditureCell";

@implementation ExpenditureListViewController

- (void)initialise {
    [super initialise];
    [self initaliseToolBar];
    
    self.tableView.backgroundColor = [UIColor FNRWhite];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.entryDate != nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Expenditure"];
        
        NSDate *startOfDate = [NSDate dayWithNoTime:self.entryDate];
        NSDate *endOfDate = [NSDate addNumberOfDays:1 toDate:startOfDate];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(entryDate >= %@) && (entryDate < %@)", startOfDate, endOfDate];
        [fetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        self.expenditures = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    } else {
        
    }
}

- (void)initaliseToolBar {
    self.toolBar.delegate = self;
    UIImage *closeImage = [UIImage imageNamed:@"ic_close"];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(didPressCloseButton)];
    self.toolBar.items = @[ closeButton ];
}

#pragma mark - Actions / Selectors

- (void)didPressCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ExpenditureTableCell

- (ExpenditureTableCell *)expenditureCellForIndexPath:(NSIndexPath *)indexPath {
    ExpenditureTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ExpenditureCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor FNRWhite];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(ExpenditureTableCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Expenditure *expenditure = [self.expenditures objectAtIndex:indexPath.row];
    [self setTimeForCell:cell expenditure:expenditure];
    [self setAmountForCell:cell expenditure:expenditure];
    [self setCategoryForCell:cell expenditure:expenditure];
    [self setNotesForCell:cell expenditure:expenditure];
}

- (void)setTimeForCell:(ExpenditureTableCell *)cell expenditure:(Expenditure *)expenditure {
    NSString *time = [NSDateFormatter localizedStringFromDate:expenditure.entryDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
    [cell.timestampLabel setText:time];
}

- (void)setAmountForCell:(ExpenditureTableCell *)cell expenditure:(Expenditure *)expenditure {
    NSNumberFormatter *currencyFormatter = [NSNumberFormatter new];
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *amount = [currencyFormatter stringFromNumber:expenditure.amount];
    
    [cell.amountLabel setText:amount];
}

- (void)setCategoryForCell:(ExpenditureTableCell *)cell expenditure:(Expenditure *)expenditure {
    NSString *category = expenditure.category;
    [cell.categoryIconImageView setImage:[self imageForCategory:category]];
}

- (void)setNotesForCell:(ExpenditureTableCell *)cell expenditure:(Expenditure *)expenditure {
    [cell.notesLabel setText:expenditure.notes];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static ExpenditureTableCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:ExpenditureCellIdentifier];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.expenditures count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self expenditureCellForIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma UIToolbarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - Helper

- (UIImage *)imageForCategory:(NSString *)category {
    if ([category isEqualToString:kCategoryFood]) {
        return [UIImage imageNamed:@"ic_food"];
    } else if ([category isEqualToString:kCategoryEntertainment]) {
        return [UIImage imageNamed:@"ic_entertainment"];
    } else if ([category isEqualToString:kCategoryGroceries]) {
        return [UIImage imageNamed:@"ic_grocery"];
    } else if ([category isEqualToString:kCategoryMedical]) {
        return [UIImage imageNamed:@"ic_medical"];
    } else if ([category isEqualToString:kCategoryTravel]) {
        return [UIImage imageNamed:@"ic_travel"];
    } else {
        return [UIImage imageNamed:@"ic_unknown"];
    }
}

@end
