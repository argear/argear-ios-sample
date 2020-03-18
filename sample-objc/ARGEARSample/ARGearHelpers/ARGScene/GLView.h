//
//  GLView.h
//  ARGEARSample
//
//  Created by Jihye on 23/08/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLView : UIView
@property (nonatomic, assign) BOOL useRenderer;

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (void)flushPixelBufferCache;
- (void)reset;

@end

NS_ASSUME_NONNULL_END
