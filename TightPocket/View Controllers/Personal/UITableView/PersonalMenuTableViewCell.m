//
//  PersonalMenuTableViewCell.m
//  TightPocket
//
//  Created by Peter Su on 14/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "PersonalMenuTableViewCell.h"

@interface PersonalMenuTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation PersonalMenuTableViewCell

- (void)awakeFromNib {
    self.nameLabel.font = [UIFont systemFontOfSize:17.0];
    self.descriptionLabel.font = [UIFont systemFontOfSize:12.0];
    self.backgroundColor = [UIColor FNRWhite];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMenuItem:(MenuItem)menuItem {
    NSString *name = @"";
    NSString *description = @"";
    BOOL toggleHidden = YES;
    _menuItem = menuItem;
    switch (menuItem) {
        case MenuItemSetBudget: {
            name = @"Budget";
            description = @"Change your budget";
            break;
        }
        case MenuItemSetStrictMode: {
            name = @"Strict Mode";
            description = @"Strict mode disallows you from adding more expenses to previous days";
            toggleHidden = NO;
            break;
        }
        case MenuItemViewStats: {
            name = @"Stats";
            description = @"View your expense stats";
            break;
        }
        default: {
            break;
        }
    }
    
    self.nameLabel.text = name;
    self.descriptionLabel.text = description;
    self.toggle.hidden = toggleHidden;
}

#pragma mark - FNRTableCellProtocol

+ (UINib *)nib {
    return [UINib nibWithNibName:@"PersonalMenuCell" bundle:nil];
}

+ (CGFloat)cellHeight {
    return 80.0f;
}

+ (NSString *)cellIdentifier {
    return @"PersonalMenuCell";
}

@end
