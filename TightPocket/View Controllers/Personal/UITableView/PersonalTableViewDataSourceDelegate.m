//
//  PersonalTableViewDataSourceDelegate.m
//  TightPocket
//
//  Created by Peter Su on 14/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "PersonalTableViewDataSourceDelegate.h"

@interface PersonalTableViewDataSourceDelegate ()

@property (strong, nonatomic) NSArray *menuItems;

@end

@implementation PersonalTableViewDataSourceDelegate

- (instancetype)init {
    if (self = [super init]) {
        self.menuItems = @[];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PersonalMenuTableViewCell cellIdentifier] forIndexPath:indexPath];
    
    BOOL odd = indexPath.row % 2 == 0;
    cell.accessoryType = (odd) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = (odd) ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleDefault;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PersonalMenuTableViewCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

@end
