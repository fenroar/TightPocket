//
//  FNRViewController.h
//  TightPocket
//
//  Created by Peter Su on 02/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FNRViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

- (void)initialise;

@end
