//
//  SetBudgetViewController.m
//  TightPocket
//
//  Created by Peter Su on 16/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "SetBudgetViewController.h"

@interface SetBudgetViewController () <UIToolbarDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UISwitch *budgetSwitch;

@end

@implementation SetBudgetViewController

- (void)initialise {
    [super initialise];
    [self initaliseToolBar];
    [self initialiseBudgetSwitch];
}

- (void)initaliseToolBar {
    self.toolBar.delegate = self;
    UIImage *closeImage = [UIImage imageNamed:@"ic_close"];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(didPressCloseButton)];
    self.toolBar.items = @[ closeButton ];
}

- (void)initialiseBudgetSwitch {
    BOOL switchIsOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserSetBudget"];
    self.budgetSwitch.on = switchIsOn;
    
    [self.budgetSwitch addTarget:self action:@selector(didChangeValueForSwitch:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Actions / Selectors

- (void)didPressCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didChangeValueForSwitch:(UISwitch *)aSwitch {
    if (aSwitch == self.budgetSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:aSwitch.on forKey:@"UserSetBudget"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - UIToolbarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
