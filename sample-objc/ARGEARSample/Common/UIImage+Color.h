//
//  UIImage+Color.h
//  ARGEARSample
//
//  Created by Jihye on 11/11/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define BUTTON_HIGHLIGHTED_ALPHA 0.5f

@interface UIImage(Color)

- (UIImage *)imageWithAlphaComponent:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
