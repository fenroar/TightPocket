//
//  FNRLabel.m
//  TightPocket
//
//  Created by Peter Su on 07/09/2015.
//  Copyright (c) 2015 fenroar. All rights reserved.
//

#import "FNRLabel.h"

@implementation FNRLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}

@end
