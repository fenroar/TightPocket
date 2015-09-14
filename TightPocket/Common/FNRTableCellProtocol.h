//
//  FNRTableCellProtocol.h
//  TightPocket
//
//  Created by Peter Su on 14/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FNRTableCellProtocol <NSObject>

+ (UINib *)nib;
+ (CGFloat)cellHeight;
+ (NSString *)cellIdentifier;

@end
