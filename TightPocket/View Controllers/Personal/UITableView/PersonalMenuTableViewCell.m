//
//  PersonalMenuTableViewCell.m
//  TightPocket
//
//  Created by Peter Su on 14/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "PersonalMenuTableViewCell.h"

@implementation PersonalMenuTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor FNRWhite];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
