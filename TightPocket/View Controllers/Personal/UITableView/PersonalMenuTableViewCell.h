//
//  PersonalMenuTableViewCell.h
//  TightPocket
//
//  Created by Peter Su on 14/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNRTableCellProtocol.h"

typedef NS_ENUM(NSInteger, MenuItem) {
    MenuItemSetBudget,
    MenuItemSetStrictMode,
    MenuItemViewStats,
    MenuItemUnknown
};

@interface PersonalMenuTableViewCell : UITableViewCell <FNRTableCellProtocol>

@property (weak, nonatomic) IBOutlet UISwitch *toggle;
@property (nonatomic) MenuItem menuItem;

@end
