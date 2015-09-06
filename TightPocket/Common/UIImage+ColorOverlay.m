//
//  UIImage+ColorOverlayCategory.m
//  Created by Tobias Reiss, @basecode on 1/8/12.
//  Renamed to ColorOverlay
//

#import <UIKit/UIKit.h>

@implementation UIImage (ColorOverlay)

- (UIImage*)imageWithColorOverlay:(UIColor*)colorOverlay
{
    // create drawing context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    // draw current image
    [self drawAtPoint:CGPointZero];
    
    // determine bounding box of current image
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // get drawing context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // flip orientation
    CGContextTranslateCTM(context, 0.0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set overlay
    CGContextSetBlendMode(context, kCGBlendModeColor);
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetFillColorWithColor(context, colorOverlay.CGColor);
    CGContextFillRect(context, rect);
    
    // save drawing-buffer
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end drawing context
    UIGraphicsEndImageContext();
    
    return returnImage;
}

@end