//
//  UIView+Toast.h
//  ARGEARSample
//
//  Created by Jihye on 2020/03/19.
//  Copyright © 2020 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView(Toast)

- (void)showToast:(NSString *)message position:(CGPoint)position;

@end

NS_ASSUME_NONNULL_END
