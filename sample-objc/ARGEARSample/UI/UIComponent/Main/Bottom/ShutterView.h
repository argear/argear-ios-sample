//
//  ShutterView.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShutterView : UIView

@property (nonatomic, assign) NSInteger mode;

- (void)setRatio:(ARGMediaRatio)ratio;

- (void)setPhotoMode;
- (void)setVideoMode;

@end

NS_ASSUME_NONNULL_END
