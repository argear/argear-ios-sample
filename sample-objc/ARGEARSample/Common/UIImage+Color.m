//
//  UIImage+Color.m
//  ARGEARSample
//
//  Created by Jihye on 11/11/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage(Color)

- (UIImage *)imageWithAlphaComponent:(CGFloat)alpha {
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);

    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);

    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextSetAlpha(context, alpha);
    CGContextDrawImage(context, area, [self CGImage]);

    UIImage *alphaImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return alphaImage;
}

@end
