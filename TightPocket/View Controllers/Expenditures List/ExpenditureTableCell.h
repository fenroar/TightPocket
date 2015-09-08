//
//  ExpenditureTableCell.h
//  TightPocket
//
//  Created by Peter Su on 04/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FNRLabel.h"

@interface ExpenditureTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet FNRLabel *timestampLabel;
@property (weak, nonatomic) IBOutlet FNRLabel *amountLabel;
@property (weak, nonatomic) IBOutlet FNRLabel *notesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryIconImageView;

@end
