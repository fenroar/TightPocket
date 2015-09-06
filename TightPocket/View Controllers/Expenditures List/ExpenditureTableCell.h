//
//  ExpenditureTableCell.h
//  TightPocket
//
//  Created by Peter Su on 04/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenditureTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
