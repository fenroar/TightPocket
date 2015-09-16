//
//  PersonalTableViewDataSourceDelegate.m
//  TightPocket
//
//  Created by Peter Su on 14/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "PersonalTableViewDataSourceDelegate.h"
#import "PersonalMenuTableViewCell.h"

@interface PersonalTableViewDataSourceDelegate ()

@property (strong, nonatomic) NSArray *menuItems;

@end

@implementation PersonalTableViewDataSourceDelegate

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self.tableView = tableView;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[PersonalMenuTableViewCell nib]
             forCellReuseIdentifier:[PersonalMenuTableViewCell cellIdentifier]];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.menuItems = @[ [NSNumber numberWithInteger:MenuItemSetBudget],
                            [NSNumber numberWithInteger:MenuItemSetStrictMode],
                            [NSNumber numberWithInteger:MenuItemViewStats] ];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonalMenuTableViewCell cellIdentifier] forIndexPath:indexPath];
    [self configureMenuCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForMenuCellAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuItems count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    	
    if (indexPath.row < [self.menuItems count]) {
        MenuItem menuItem = [[self.menuItems objectAtIndex:indexPath.row] integerValue];
        [self didSelectMenuItem:menuItem];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *blankView = [UIView new];
    return blankView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 24.0f;
}

#pragma mark - Helpers

- (void)switchDidChange:(UISwitch *)toggle {
    CGPoint switchPositionPoint = [toggle convertPoint:CGPointZero toView:[self tableView]];
    NSIndexPath *indexPath = [[self tableView] indexPathForRowAtPoint:switchPositionPoint];
    
    MenuItem menuItem = [[self.menuItems objectAtIndex:indexPath.row] integerValue];
    switch (menuItem) {
        case MenuItemSetStrictMode: {
            [[NSUserDefaults standardUserDefaults] setBool:toggle.on forKey:@"UserStrictMode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        }
        default:
            break;
    }
}

- (void)didSelectMenuItem:(MenuItem)menuItem {
    switch (menuItem) {
        case MenuItemSetBudget:
            if ([self.delegate respondsToSelector:@selector(didSelectMenuItemSetBudget)]) {
                [self.delegate didSelectMenuItemSetBudget];
            }
            break;
        case MenuItemViewStats:
            if ([self.delegate respondsToSelector:@selector(didSelectMenuItemStats)]) {
                [self.delegate didSelectMenuItemStats];
            }
        default:
            break;
    }
}

- (void)configureMenuCell:(PersonalMenuTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.menuItems count]) {
        MenuItem menuItem = [[self.menuItems objectAtIndex:indexPath.row] integerValue];
        cell.menuItem = menuItem;
        if (menuItem == MenuItemSetStrictMode) {
            cell.toggle.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserStrictMode"];
        }
    } else {
        cell.menuItem = MenuItemUnknown;
    }
    [cell.toggle addTarget:self action:@selector(switchDidChange:) forControlEvents:UIControlEventValueChanged];
}


- (CGFloat)heightForMenuCellAtIndexPath:(NSIndexPath *)indexPath {
    static PersonalMenuTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:[PersonalMenuTableViewCell cellIdentifier]];
    });
    
    [self configureMenuCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

@end
