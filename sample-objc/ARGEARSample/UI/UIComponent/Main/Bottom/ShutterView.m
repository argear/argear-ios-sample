//
//  ShutterView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "ShutterView.h"


@interface ShutterView () {
}
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *innerCircleLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation ShutterView

// Full
#define kShutterViewFullBorderColor [[UIColor whiteColor] CGColor]
#define kShutterViewFullFillColor [[[UIColor whiteColor] colorWithAlphaComponent:0.3f] CGColor]
#define kShutterViewFullInnerCircleColor [[UIColor whiteColor] CGColor]
// 4:3, 1:1
#define kShutterViewPinkBorderColor [[UIColor colorWithRed:48.f/255.f green:99.f/255.f blue:230.f/255.f alpha:1.f] CGColor]
#define kShutterViewPinkFillColor [[UIColor colorWithRed:48.f/255.f green:99.f/255.f blue:230.f/255.f alpha:0.3f] CGColor]
#define kShutterViewPinkInnerCircleColor [[UIColor colorWithRed:48.f/255.f green:99.f/255.f blue:230.f/255.f alpha:1.f] CGColor]

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _mode = ARGMediaModePhoto;

    // base circle
    _circleLayer = [CAShapeLayer layer];
    [_circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(3, 3, 61, 61)] CGPath]];
    [_circleLayer setLineWidth:6];
    [_circleLayer setStrokeColor:kShutterViewPinkBorderColor];
    [_circleLayer setFillColor:kShutterViewPinkFillColor];
    [_circleLayer setShadowColor:[[UIColor colorWithRed:97.f/255.f green:97.f/255.f blue:97.f/255.f alpha:0.16f] CGColor]];
    [_circleLayer setShadowOpacity:0.5f];
    [_circleLayer setShadowOffset:CGSizeMake(0.1f, 0.1f)];
    [_circleLayer setMasksToBounds:NO];
    
    [[self layer] addSublayer:_circleLayer];

    // inner circle
    _innerCircleLayer = [CAShapeLayer layer];
    CGPoint arcCenter = CGPointMake(CGRectGetMidY(self.bounds), CGRectGetMidX(self.bounds));
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:6.75 startAngle:-M_PI_2 endAngle:M_PI+M_PI_2 clockwise:YES];
    [_innerCircleLayer setPath:[innerPath CGPath]];
    [_innerCircleLayer setLineWidth:13.5];
    [_innerCircleLayer setStrokeColor:[[UIColor clearColor] CGColor]];
    [_innerCircleLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    [[self layer] addSublayer:_innerCircleLayer];

    // progress circle
    _progressLayer = [CAShapeLayer layer];
//    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:30.5 startAngle:-M_PI_2 endAngle:M_PI+M_PI_2 clockwise:YES];
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:30.5 startAngle:-M_PI_2 endAngle:M_PI+M_PI_4 clockwise:YES];

    [_progressLayer setPath:[progressPath CGPath]];
    [_progressLayer setLineWidth:6];
    [_progressLayer setStrokeColor:[[UIColor colorWithRed:255.0/255.0 green:202.0/255.0 blue:212.0/255.0 alpha:1.0] CGColor]];
    [_progressLayer setFillColor:[[UIColor clearColor] CGColor]];

//    [[self layer] addSublayer:_progressLayer];
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    if (ratio == ARGMediaRatio_16x9) {
        
        [_circleLayer setStrokeColor:kShutterViewFullBorderColor];
        [_circleLayer setFillColor:kShutterViewFullFillColor];
        
        if (_mode == ARGMediaModeVideo) {
            [_innerCircleLayer setStrokeColor:kShutterViewFullInnerCircleColor];
        }
    } else {
        
        [_circleLayer setStrokeColor:kShutterViewPinkBorderColor];
        [_circleLayer setFillColor:kShutterViewPinkFillColor];
        
        if (_mode == ARGMediaModeVideo) {
            [_innerCircleLayer setStrokeColor:kShutterViewPinkInnerCircleColor];
        }
    }
}

- (void)setShutterMode:(ARGMediaMode)mode {
    
    switch (mode) {
        case ARGMediaModePhoto:
            [self setPhotoMode];
            break;
        case ARGMediaModeVideo:
            [self setVideoMode];
            break;
        default:
            break;
    }
}

- (void)setPhotoMode {
    _mode = ARGMediaModePhoto;
    
    [_innerCircleLayer setStrokeColor:[[UIColor clearColor] CGColor]];
}

- (void)setVideoMode {
    _mode = ARGMediaModeVideo;
    
    if ([_circleLayer strokeColor] == kShutterViewFullBorderColor) {
        
        [_innerCircleLayer setStrokeColor:kShutterViewFullInnerCircleColor];
    } else {
        
        [_innerCircleLayer setStrokeColor:kShutterViewPinkInnerCircleColor];
    }
}

# pragma mark - Observers
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"mode"]) {
        ARGMediaMode mode = [[change objectForKey:@"new"] integerValue];
        
        [self setShutterMode:mode];
    }
}

@end
