//
//  ExpenditureCategoryViewController.m
//  TightPocket
//
//  Created by Peter Su on 04/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "ExpenditureCategoryViewController.h"
#import "Expenditure.h"
#import "CategoryTableCell.h"

@interface ExpenditureCategoryViewController () <UIToolbarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *categories;

@end

static NSString * const CategoryCellIdentifier = @"CategoryCell";

@implementation ExpenditureCategoryViewController

- (void)initialise {
    [super initialise];
    [self initaliseToolBar];
    self.categories = @[ kCategoryFood,
                         kCategoryTravel,
                         kCategoryEntertainment,
                         kCategoryGroceries,
                         kCategoryMedical,
                         kCategoryOther];
    
    self.tableView.backgroundColor = [UIColor FNRWhite];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)initaliseToolBar {
    self.toolBar.delegate = self;
    UIImage *closeImage = [UIImage imageNamed:@"ic_close"];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(didPressCloseButton)];
    
    UILabel *label = [UILabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"Category";
    [self.view addSubview:label];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.toolBar attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.toolBar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    self.toolBar.items = @[ closeButton ];
}

#pragma mark - Actions / Selectors 

- (void)didPressCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CategoryCell

- (CategoryTableCell *)categoryCellForIndexPath:(NSIndexPath *)indexPath {
    CategoryTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor FNRWhite];
    NSString *category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = category;
    return cell;
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self categoryCellForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectCategory:)]) {
        NSString *category = [self.categories objectAtIndex:indexPath.row];
        [self.delegate didSelectCategory:category];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIToolbarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
