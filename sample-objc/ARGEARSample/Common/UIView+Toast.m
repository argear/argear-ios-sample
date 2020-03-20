//
//  UIView+Toast.m
//  ARGEARSample
//
//  Created by Jihye on 2020/03/19.
//  Copyright © 2020 Seerslab. All rights reserved.
//

#import "UIView+Toast.h"
#import <Toast.h>

@implementation UIView(Toast)

- (void)showToast:(NSString *)message position:(CGPoint)position {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    [style setMessageFont:[UIFont systemFontOfSize:11]];
    [style setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    [style setMessageColor:[[UIColor whiteColor] colorWithAlphaComponent:0.75]];
    [style setCornerRadius:16];

    [self makeToast:message duration:1.5 position:[NSValue valueWithCGPoint:position] style:style];
}

@end
