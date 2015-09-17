//
//  ProfileViewController.m
//  TightPocket
//
//  Created by Peter Su on 13/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalTableViewDataSourceDelegate.h"
#import "SetBudgetViewController.h"
#import "StatsViewController.h"

@interface PersonalViewController () <MenuProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PersonalTableViewDataSourceDelegate *tableViewDataSourceDelegate;

@end

@implementation PersonalViewController

- (void)initialise {
    [super initialise];
    self.tableViewDataSourceDelegate = [[PersonalTableViewDataSourceDelegate alloc] initWithTableView:self.tableView];
    self.tableViewDataSourceDelegate.delegate = self;
}

#pragma mark - MenuProtocol

- (void)didSelectMenuItemSetBudget {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SetBudgetViewController *budgetVC = [storyboard instantiateViewControllerWithIdentifier:@"BudgetVC"];
    [self presentViewController:budgetVC animated:YES completion:nil];
}

- (void)didSelectMenuItemStats {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StatsViewController *statsVC = [storyboard instantiateViewControllerWithIdentifier:@"StatsVC"];
    statsVC.managedObjectContext = self.managedObjectContext;
    [self presentViewController:statsVC animated:YES completion:nil];
}

@end
