//
//  ProfileViewController.m
//  TightPocket
//
//  Created by Peter Su on 13/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalTableViewDataSourceDelegate.h"

@interface PersonalViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PersonalTableViewDataSourceDelegate *tableViewDataSourceDelegate;

@end

@implementation PersonalViewController

- (void)initialise {
    [super initialise];
    
    [self.tableView registerNib:[PersonalMenuTableViewCell nib]
         forCellReuseIdentifier:[PersonalMenuTableViewCell cellIdentifier]];
    
    self.tableViewDataSourceDelegate = [PersonalTableViewDataSourceDelegate new];
    self.tableView.delegate = self.tableViewDataSourceDelegate;
    self.tableView.dataSource = self.tableViewDataSourceDelegate;
}

@end
