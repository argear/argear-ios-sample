//
//  ARGSceneView.h
//  ARGEARSample
//
//  Created by Jaecheol Kim on 2019/11/11.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARGScene : NSObject
@property (nonatomic, assign) ARGMediaRatio currentRatio;
@property (nonatomic, strong) GLView *glPreview;
@property (nonatomic, assign) CGAffineTransform viewTransform;

- (id)initSceneviewAt:(UIView *_Nullable)view withViewTransform:(CGAffineTransform) viewTransform;
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (void)flushPixelBufferCache;
- (void)cleanGLPreview;

- (void)sceneViewRatio:(ARGMediaRatio)ratio;
- (void)dispalyTransform:(CGAffineTransform)viewTransform;
@end

NS_ASSUME_NONNULL_END
