//
//  ARGSceneView.m
//  ARGEARSample
//
//  Created by Jaecheol Kim on 2019/11/11.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "ARGScene.h"
@interface ARGScene ()
@property (nonatomic, assign) UIView * _Nullable mainView;
@property (nonatomic, assign) CGRect glBound;
@property (nonatomic, assign) CGRect glFrame;
@end

@implementation ARGScene

- (id)initSceneviewAt:(UIView *_Nullable)view withViewTransform:(CGAffineTransform) viewTransform {
    self = [super init];
    if (self) {
        _mainView = view;
        _viewTransform = viewTransform;
        _currentRatio = ARGMediaRatio_4x3;
        [self setupGLView];
     }
    
    return self;
}

- (void)setupGLView {
    [self checkGLView];

    [self sceneViewRatio:_currentRatio];
}

- (void)checkGLView {
    if (!_glPreview) {
        _glPreview = [[GLView alloc] initWithFrame:CGRectZero];
        [_glPreview setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [_mainView insertSubview:_glPreview atIndex:0];
    }
}

- (void)sceneViewRatio:(ARGMediaRatio)ratio {
    
    [self checkGLView];
    
    _currentRatio = ratio;
    
    [_glPreview setTransform:_viewTransform];
    
    _glBound = CGRectZero;
    _glBound.size = [_mainView convertRect:_mainView.bounds toView:_glPreview].size;

    
    float ratioY = 0;
    float fullRatio = [[[UIApplication sharedApplication] keyWindow] frame].size.height / [[[UIApplication sharedApplication] keyWindow] frame].size.width;
    
    if (_currentRatio == ARGMediaRatio_16x9) {
        _glBound = CGRectMake(0, 0, _glBound.size.width,  _glBound.size.height);
    } else if (_currentRatio == ARGMediaRatio_4x3) {
        _glBound = CGRectMake(0, 0, (_glBound.size.height / 3) * 4,  _glBound.size.height);
        if (@available(iOS 11.0, *)) {
            ratioY = [[[UIApplication sharedApplication] keyWindow] safeAreaInsets].top;
        } else {
            ratioY = 0;
        }
        
        if (fullRatio > 2.0f) {
            ratioY += 64;
        }
    } else {
        // 1:1
        _glBound = CGRectMake(0, 0, _glBound.size.height,  _glBound.size.height);
        if (@available(iOS 11.0, *)) {
            ratioY = [[[UIApplication sharedApplication] keyWindow] safeAreaInsets].top + 64;
        } else {
            ratioY = 64;
        }
    }
    
    [_glPreview setBounds:_glBound];
    [_glPreview setCenter:CGPointMake(_glPreview.bounds.size.height/2.0, _glPreview.bounds.size.width/2.0 + ratioY)];
    
    _glFrame = [_glPreview frame];
}

- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    [_glPreview displayPixelBuffer:pixelBuffer];
}

- (void)dispalyTransform:(CGAffineTransform)viewTransform {
    _viewTransform = viewTransform;
    //[_glPreview setTransform:_viewTransform];
}

- (void)flushPixelBufferCache {
    [_glPreview flushPixelBufferCache];
}


- (void)cleanGLPreview {
    if (_glPreview) {
        [_glPreview reset];
        [_glPreview removeFromSuperview];
        _glPreview = nil;
    }
}

@end
