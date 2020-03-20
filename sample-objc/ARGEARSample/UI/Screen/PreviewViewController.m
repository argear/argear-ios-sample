//
//  PreviewViewController.m
//  ARGEARSample
//
//  Created by Jihye on 06/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "PreviewViewController.h"
#import "UIView+Toast.h"

#define screenRatio [[UIScreen mainScreen] bounds].size.height / [[UIScreen mainScreen] bounds].size.width
#define topInsetViewHeightConstant 64.f
#define TOAST_PREVIEW_POSITION CGPointMake([self view].center.x, [[self previewBottomFunctionView] frame].origin.y - 96.f)

@interface PreviewViewController ()

@end

@implementation PreviewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_previewBottomFunctionView setDelegate:self];
    
    if (_ratio == ARGMediaRatio_16x9 && ![self isPreviewContentOrientationIsPortrait]) {
        [_previewBottomFunctionView setImages:ARGMediaRatio_4x3];
    } else {
        [_previewBottomFunctionView setImages:_ratio];
    }
    
    switch (_mode) {
        case ARGMediaModePhoto:
            
            [self photoPreview];
            break;
        case ARGMediaModeVideo:
            
            [self videoPreview];
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backToMain {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - PreviewBottomFunctionDelegate
- (void)backButtonAction {
    [self backToMain];
}

- (void)saveButtonAction {
    // save photo, video
    
    __weak PreviewViewController *weakSelf = self;
    if (_mode == ARGMediaModePhoto) {
        
        [_media saveImageToAlbum:_previewImage success:^{
            [[self view] showToast:[@"photo_video_saved_message" localized] position:TOAST_PREVIEW_POSITION];
            [[weakSelf previewBottomFunctionView] showCheckButton];
        } error:nil];
    } else if (_mode == ARGMediaModeVideo) {

        NSURL *videoPath = [_videoInfo objectForKey:@"filePath"];
        if (!videoPath) {
            return;
        }
        
        [_media saveVideoToAlbum:videoPath success:^{
            [[self view] showToast:[@"photo_video_saved_message" localized] position:TOAST_PREVIEW_POSITION];
            [[weakSelf previewBottomFunctionView] showCheckButton];
        } error:nil];
    }
}

- (void)checkButtonAction {
    [self backToMain];
}

- (void)shareButtonAction {
}

# pragma mark - Preview
- (void)photoPreview {
    
    switch (_ratio) {
        case ARGMediaRatio_16x9:
            [_fullImageView setContentMode:UIViewContentModeScaleAspectFit];
            [_fullImageView setImage:_previewImage];
            break;
        case ARGMediaRatio_4x3:
            if (screenRatio > 2.f) {
                [_topInsetViewHeight setConstant:topInsetViewHeightConstant];
            } else {
                [_topInsetViewHeight setConstant:0];
            }
            [_ratio43ImageView setImage:_previewImage];
            break;
        case ARGMediaRatio_1x1:
            [_ratio11ImageView setImage:_previewImage];
            break;

        default:
            break;
    }
}

- (void)videoPreview {
    
    UIImageView *imageView = nil;
    switch (_ratio) {
        case ARGMediaRatio_16x9:
            imageView = _fullImageView;
            break;
        case ARGMediaRatio_4x3:
            if (screenRatio > 2.f) {
                [_topInsetViewHeight setConstant:topInsetViewHeightConstant];
            } else {
                [_topInsetViewHeight setConstant:0];
            }
            imageView = _ratio43ImageView;
            break;
        case ARGMediaRatio_1x1:
            imageView = _ratio11ImageView;
            break;
        default:
            break;
    }

    NSURL *videoPath = [_videoInfo objectForKey:@"filePath"];
    
    if (!videoPath) {
        return;
    }
    
    AVLayerVideoGravity videoGravity = AVLayerVideoGravityResizeAspect;
    // Full & Landscape
    if (_ratio == ARGMediaRatio_16x9 && [self isPreviewContentOrientationIsPortrait]) {
        videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    float topInset = 0;
    if (@available(iOS 11.0, *)) {
        topInset = [[[UIApplication sharedApplication] keyWindow] safeAreaInsets].top;
    }
    if (screenRatio > 2.f) {
        topInset += topInsetViewHeightConstant;
    } else {
        topInset += 44.f;
    }
    if (_ratio == ARGMediaRatio_16x9) {
        topInset = 0;
    }
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:videoPath];
    _player = [AVPlayer playerWithPlayerItem:playerItem];

    AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer: _player];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [avPlayerLayer setBounds:CGRectMake(0, -[imageView frame].origin.y - topInset, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [avPlayerLayer setVideoGravity:videoGravity];
    [[imageView layer] addSublayer:avPlayerLayer];

    [_player setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    
    [_player play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    [_player seekToTime:kCMTimeZero];
    [_player play];
}

- (void)viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
   
    [super viewWillDisappear:animated];
    
    [_player pause];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AVPlayerItemDidPlayToEndTimeNotification
                                                  object:nil];
}

- (BOOL)isPreviewContentOrientationIsPortrait {
    
    return UIInterfaceOrientationIsPortrait((UIInterfaceOrientation)[_media getRecordingOrientation]);
}

@end
