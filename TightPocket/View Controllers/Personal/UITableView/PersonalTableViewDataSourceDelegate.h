//
//  PersonalTableViewDataSourceDelegate.h
//  TightPocket
//
//  Created by Peter Su on 14/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MenuProtocol;

@interface PersonalTableViewDataSourceDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id<MenuProtocol> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end

@protocol MenuProtocol <NSObject>
- (void)didSelectMenuItemSetBudget;
- (void)didSelectMenuItemStats;
@end