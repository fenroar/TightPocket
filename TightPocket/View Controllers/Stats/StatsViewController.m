//
//  StatsViewController.m
//  TightPocket
//
//  Created by Peter Su on 17/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "StatsViewController.h"
#import "Expenditure.h"

@interface StatsViewController ()<ChartViewDelegate, UIToolbarDelegate>

@property (nonatomic, strong) IBOutlet PieChartView *chartView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) NSMutableDictionary *categorisedSpendings;
@property (strong, nonatomic) NSDecimalNumber *totalExpenseThisMonth;

@end

@implementation StatsViewController

- (void)initialise {
    [super initialise];
    [self initaliseToolBar];
    [self initialiseChart];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Expenditure"];

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MMMM yyyy";
    NSDate *startOfThisMonth = [NSDate startOfThisMonth];
    NSDate *startOfDate = [NSDate dayWithNoTime:startOfThisMonth];
    NSDate *endOfDate = [NSDate addNumberOfDays:1 toDate:[NSDate dayWithNoTime:[NSDate startOfToday]]];
    self.dateLabel.text = [NSString stringWithFormat:@"Expenses during %@", [dateFormatter stringFromDate:startOfThisMonth]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(entryDate >= %@) && (entryDate < %@)", startOfDate, endOfDate];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *allExpenditures = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    self.totalExpenseThisMonth = [self calculateTotalExpense:allExpenditures];
    BOOL totalIsEmpty = [self.totalExpenseThisMonth compare:[NSDecimalNumber decimalNumberWithString:@"0.00"]] != NSOrderedDescending;
    if ( totalIsEmpty || [allExpenditures count] <= 0) {
        _chartView.drawHoleEnabled = YES;
        _chartView.centerText = @"No data";
    } else {
        _chartView.drawHoleEnabled = NO;
        _chartView.centerText = @"";
    }
    
    NSArray *categories = @[ kCategoryFood, kCategoryEntertainment, kCategoryGroceries, kCategoryMedical, kCategoryTravel, kCategoryOther ];
    self.categorisedSpendings = [NSMutableDictionary new];
    for (NSString *category in categories) {
        NSDecimalNumber *totalCategoryExpenses = [self calculateTotalExpense:allExpenditures forCategory:category];
        [self.categorisedSpendings setObject:totalCategoryExpenses forKey:category];
    }
    
    [self setDataForChart];
}

- (void)initaliseToolBar {
    self.toolBar.delegate = self;
    UIImage *closeImage = [UIImage imageNamed:@"ic_close"];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(didPressCloseButton)];
    
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"Statistics";
    [self.view addSubview:label];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.toolBar attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.toolBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    self.toolBar.items = @[ closeButton ];
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

- (void)initialiseChart {
    _chartView.backgroundColor = [UIColor FNRWhite];
    _chartView.holeColor = [UIColor FNRWhite];
    _chartView.delegate = self;
    _chartView.usePercentValuesEnabled = YES;
    _chartView.holeTransparent = YES;
    _chartView.centerTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    _chartView.descriptionText = @"";
    
    ChartLegend *l = _chartView.legend;
    l.position = ChartLegendPositionRightOfChart;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    
    [_chartView animateWithXAxisDuration:1.5 yAxisDuration:1.5 easingOption:ChartEasingOptionEaseOutBack];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataForChart {
    NSArray *categoryKeys = [self.categorisedSpendings allKeys];
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    NSInteger index = 0;
    for (NSString *category in categoryKeys) {
        NSDecimalNumber *decimalNumber = [self.categorisedSpendings objectForKey:category];
        [xVals addObject:category];
        [yVals1 addObject:[[BarChartDataEntry alloc] initWithValue:[decimalNumber doubleValue] xIndex:index]];
        index++;
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yVals1 label:@"Expense Categories"];
    dataSet.sliceSpace = 0.0f;
    dataSet.selectionShift = 8.0f;
    
    // add a lot of colors
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    dataSet.colors = colors;
    
    PieChartData *data = [[PieChartData alloc] initWithXVals:xVals dataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:pFormatter];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:[UIColor blackColor]];
    
    _chartView.data = data;
    [_chartView highlightValues:nil];
}

#pragma mark - Actions / Selectors

- (void)didPressCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIToolbarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSString *category = [[self.categorisedSpendings allKeys] objectAtIndex:entry.xIndex];
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}


@end
