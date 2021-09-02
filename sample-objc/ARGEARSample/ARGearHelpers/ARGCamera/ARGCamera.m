//
//  Camera.m
//  ARGEARSample
//
//  Created by Jihye on 19/08/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "ARGCamera.h"

@implementation ARGCamera

- (id)init {
    self = [super init];
    if (self) {
        _isDisplaying = NO;
        
        _sessionPreset = AVCaptureSessionPresetHigh;
        _currentCameraPosition = AVCaptureDevicePositionFront;
        _currentRatio = ARGMediaRatio_4x3;
        
        _sessionQueue = dispatch_queue_create("camera.session.queue", DISPATCH_QUEUE_SERIAL);
        _videoDataOutputQueue = dispatch_queue_create("camera.videodataoutput.queue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(_videoDataOutputQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    }
    
    return self;
}

- (void)setupCamera {
    if (_captureSession) {
        return;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession setSessionPreset:_sessionPreset];

    // init device
    AVCaptureDevice *device = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:_currentCameraPosition];
    CMTime frameDuration = kCMTimeInvalid;
    frameDuration = CMTimeMake(1, DEFAULT_FRAMERATE);

    NSError *error = nil;
    if ([device lockForConfiguration:&error]) {
        if ([device isSmoothAutoFocusSupported]) {
            [device setSmoothAutoFocusEnabled:YES];
        }

        if ([device respondsToSelector:@selector(setActiveVideoMaxFrameDuration:)]) {
            [device setActiveVideoMaxFrameDuration:frameDuration];
        }
        
        if ([device respondsToSelector:@selector(setActiveVideoMinFrameDuration:)]) {
            [device setActiveVideoMinFrameDuration:frameDuration];
        }

        [device unlockForConfiguration];
    } else {
    }
    [self setDevice:device];

    // init input
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    if ([_captureSession canAddInput:input]) {
        [_captureSession addInput:input];
    }
    [self setDeviceInput:input];

    // init output
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoOut setVideoSettings:videoSettings];
    [videoOut setSampleBufferDelegate:self queue:_videoDataOutputQueue];
    [videoOut setAlwaysDiscardsLateVideoFrames:YES];

    if ([_captureSession canAddOutput:videoOut]) {
        [_captureSession addOutput:videoOut];
    }
    _videoConnection = [videoOut connectionWithMediaType:AVMediaTypeVideo];

    _videoOrientation = [_videoConnection videoOrientation];
}

- (void)startCamera {
    dispatch_sync(_sessionQueue, ^{
        [self setupCamera];
        [_captureSession startRunning];
    });
}

- (void)stopCamera {
    dispatch_sync(_sessionQueue, ^{
        [_captureSession stopRunning];
        [self teardownCaptureSession];
    });
}

#pragma mark - Control _captureSession
- (void)teardownCaptureSession {
    if (_captureSession) {
        _captureSession = nil;
    }
}
                               
- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

// Samplebuffer delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
      
    __weak ARGCamera *weakSelf = self;
    if (_delegate != nil && [_delegate respondsToSelector:@selector(didOutputSampleBuffer: fromConnection:)]) {
        [[weakSelf delegate] didOutputSampleBuffer:sampleBuffer fromConnection:connection];
    }
}

#pragma mark - Camera Functions
- (void)toggleCamera:(void (^_Nullable)(void))completion {
    if (_currentCameraPosition == AVCaptureDevicePositionBack) {
        _currentCameraPosition = AVCaptureDevicePositionFront;
    } else if (_currentCameraPosition == AVCaptureDevicePositionFront) {
        _currentCameraPosition = AVCaptureDevicePositionBack;
    }
    
    [self stopCamera];
    [self startCamera];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion();
    });
}

- (void)changeCameraRatio:(void (^_Nullable)(void))completion {
    // 4:3 → 1:1 → Full
    if (_currentRatio == ARGMediaRatio_4x3) {
        [self setCurrentRatio:ARGMediaRatio_1x1];
    } else if (_currentRatio == ARGMediaRatio_1x1) {
        [self setCurrentRatio:ARGMediaRatio_16x9];
    } else if (_currentRatio == ARGMediaRatio_16x9) {
        [self setCurrentRatio:ARGMediaRatio_4x3];
    }
    
    [self stopCamera];
    [self startCamera];

    dispatch_async(dispatch_get_main_queue(), ^{
        completion();
    });
}

@end
