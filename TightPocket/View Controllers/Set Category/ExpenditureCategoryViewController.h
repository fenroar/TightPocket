//
//  ExpenditureCategoryViewController.h
//  TightPocket
//
//  Created by Peter Su on 04/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "FNRViewController.h"

@protocol ExpenditureCategoryDelegate;

@interface ExpenditureCategoryViewController : FNRViewController

@property (weak, nonatomic) id<ExpenditureCategoryDelegate>delegate;

@end

@protocol ExpenditureCategoryDelegate <NSObject>

- (void)didSelectCategory:(NSString *)category;

@end
