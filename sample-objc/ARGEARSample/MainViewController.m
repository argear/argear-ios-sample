//
//  MainViewController.m
//  ARGEARSample
//
//  Created by Jihye on 05/08/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "MainViewController.h"
#import "ARGCamera.h"
#import "ARGScene.h"
#import "ARGPreferences.h"

#import "NetworkManager.h"
#import "FilterManager.h"
#import "StickerManager.h"
#import "BeautyManager.h"
#import "BulgeManager.h"

#import "PreviewViewController.h"

#import <ARGear/ARGear.h>
#import "UIView+Toast.h"
#import "Utils.h"

@interface MainViewController () <ARGCameraDelegate, ARGSessionDelegate>
@property (nonatomic, strong) ARGSession *argSession;       // ARGear Session (ARGear main handler)
@property (nonatomic, strong) ARGMedia *argMedia;           // ARGear Media (ARGear Video / Photo)

@property (nonatomic, strong) ARGScene *sceneView;          // Rendering
@property (nonatomic, strong) ARGCamera *camera;            // Camera
@property (nonatomic, strong) ARGPreferences *preferences;  // Options

@end

@implementation MainViewController

#define TOAST_MAIN_POSITION CGPointMake([self view].center.x, [[self mainBottomFunctionView] frame].origin.y + 24.f)

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialize];
    [self initHelpers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self runARGSession];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [self removeObservers];
}

- (void)initialize {

    [self setupConfig];

    [self setupCamera];
    
    [self setupScene];
    
    [self setupUI];
}

- (void)initHelpers {

    [[FilterManager shared] setSession:_argSession];
    [[StickerManager shared] setSession:_argSession];
    [[BeautyManager shared] setSession:_argSession];
    [[BulgeManager shared] setSession:_argSession];
    
    [[NetworkManager shared] setSession:_argSession];
    [[NetworkManager shared] connectAPI:^(BOOL success, NSDictionary * _Nullable data) {
        if (success) {
            [[RealmManager shared] setAPIData:data];
        }
    }];
    
    [[BeautyManager shared] start];
    [[Utils shared] setBoolValue:UTILS_PHOTOSAVE_NEED_SHOW_MESSAGE value:YES];
}


// MARK: - ARGearSDK setup & run
- (void)setupConfig {
    
    ARGConfig *argConfig = [[ARGConfig alloc] initWithApiURL:API_HOST apiKey:API_KEY secretKey:API_SECRET_KEY authKey:API_AUTH_KEY];

    NSError * error;
    ARGInferenceFeature inferenceFeature = ARGInferenceFeatureFaceLowTracking;
    _argSession = [[ARGSession alloc] initWithARGConfig:argConfig feature:inferenceFeature error:&error];
    _argSession.delegate = self;
}

- (void)runARGSession {
    
    [_argSession run];

    ARGInferenceDebugOption debugOption = [_preferences showLandmark] ? ARGInferenceOptionDebugFaceLandmark2D : ARGInferenceOptionDebugNON;
    [_argSession setInferenceDebugOption:debugOption];
}

// MARK: - Camera , Scene, Media setup & run

- (void)setupCamera {
    _camera = [[ARGCamera alloc] init];
    
    __weak MainViewController *weakSelf = self;
    [self permissionCheck:^{

        [[weakSelf camera] setDelegate:self];
        [[weakSelf camera] startCamera];
        
        [self setCameraInfo];
    }];
}

- (void)setCameraInfo {
    
    if (!_preferences) {
        _preferences = [[ARGPreferences alloc] init];
    }
    
    if(!_argMedia){
        _argMedia = [[ARGMedia alloc] init];
    }
    
    [_argMedia setVideoDevice:[_camera device]];
    [_argMedia setVideoDeviceOrientation:[_camera videoOrientation]];
    [_argMedia setVideoConnection:[_camera videoConnection]];
    [_argMedia setMediaRatio:[_camera currentRatio]];
    
    [_argMedia setVideoBitrate:[_preferences videoBitrate]];
}

- (void)setupScene {

    CGAffineTransform displayTramsform = [_argSession.frame displayTransform];
    _sceneView = [[ARGScene alloc] initSceneviewAt:self.view withViewTransform:displayTramsform];
}



// MARK: - UI
- (void)setupUI {
    [_splashView removeFromSuperview];
    [_mainTopFunctionView setDelegate:self];
    [_mainBottomFunctionView setDelegate:self];
    [_ratioView setRatio:[_camera currentRatio]];
    [_settingView setPreferencesWithAutoSave:[_argMedia autoSave] showLandmark:[_preferences showLandmark] videoBitrate:[_preferences videoBitrate]];
    [ARGLoading prepare];
    [self addObservers];
}

- (void)addObservers {
    [[_settingView autoSaveSwitch] addObserver:self forKeyPath:@"tag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[_settingView faceLandmarkSwitch] addObserver:self forKeyPath:@"tag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[_settingView bitrateSegmentedControl] addObserver:self forKeyPath:@"tag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    // change ratio
    [_camera addObserver:_mainTopFunctionView forKeyPath:@"currentRatio" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [_camera addObserver:_mainBottomFunctionView forKeyPath:@"currentRatio" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObservers {
    [[_settingView autoSaveSwitch] removeObserver:self forKeyPath:@"tag" context:nil];
    [[_settingView faceLandmarkSwitch] removeObserver:self forKeyPath:@"tag" context:nil];
    [[_settingView bitrateSegmentedControl] removeObserver:self forKeyPath:@"tag" context:nil];
    
    [_camera removeObserver:_mainTopFunctionView forKeyPath:@"currentRatio"];
    [_camera removeObserver:_mainBottomFunctionView forKeyPath:@"currentRatio"];
}

- (void)goPreview:(UIImage *)image {
    [self performSegueWithIdentifier:@"toPreviewSegue" sender:image];
}

- (void)goPreviewVideo:(NSDictionary *)videoInfo {
    [self performSegueWithIdentifier:@"toPreviewSegue" sender:videoInfo];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toPreviewSegue"]) {
        PreviewViewController *previewController = (PreviewViewController *)segue.destinationViewController;
        
        [previewController setRatio:[_camera currentRatio]];
        [previewController setMedia:_argMedia];
 
        if ([sender isKindOfClass:[UIImage class]]) {
            
            [previewController setMode:ARGMediaModePhoto];
            [previewController setPreviewImage:sender];
        } else if ([sender isKindOfClass:[NSDictionary class]]) {
            
            [previewController setMode:ARGMediaModeVideo];
            [previewController setVideoInfo:sender];
        }
    }
}


- (void)removeSplashAfter:(float)sec {
    __weak MainViewController *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[weakSelf splashView] removeFromSuperview];
    });
}

// MARK: - Permission
- (void)permissionCheck:(PermissionGrantedBlock)granted {
    
    [_permissionView permissionCheck:granted];

    Permission *permission = [[Permission alloc] init];
    PermissionLevel permissionLevel = [permission getPermissionLevel];

    switch (permissionLevel) {
       case PermissionLevelNone:

           [self removeSplashAfter:1.0f];

           break;
       case PermissionLevelRestricted:

           [self removeSplashAfter:1.0f];

           break;
       case PermissionLevelGranted:

           break;
       default:
           break;
    }
}

// MARK: - MainTopFunctionDelegate
- (void)settingButtonAction {
    [_settingView open];
}

- (void)ratioButtonAction {
    [self pauseUI];
    [self clean];
    
    __weak MainViewController *weakSelf = self;
    [_camera changeCameraRatio:^{
        [weakSelf startUI];
        [weakSelf refreshRatio];
    }];
}

- (void)toggleButtonAction {
    [self pauseUI];
    [self clean];
    
     __weak MainViewController *weakSelf = self;
    [_camera toggleCamera:^{
        [weakSelf startUI];
        [weakSelf refreshRatio];
    }];
}

- (void)clean {
    [_sceneView cleanGLPreview];
}

- (void)refreshRatio {
    CGAffineTransform displayTramsform = [_argSession.frame displayTransform];
    [_sceneView setViewTransform:displayTramsform];
    [_ratioView setRatio:_camera.currentRatio];
    [_sceneView sceneViewRatio:_camera.currentRatio];
    [_argMedia setMediaRatio:[_camera currentRatio]];
}

- (void)startUI {
    [self setCameraInfo];
    [self touchLock:NO];
    [_argSession run];
}

- (void)pauseUI {
    [self touchLock:YES];
    [_argSession pause];
}

// MARK: - MainBottomFunctionDelegate
- (void)takePictureAction:(UIButton *)sender {
    
    [_argMedia takePic:^(UIImage * _Nonnull image) {
        [self takePictureFinished:image];
    }];
}

- (void)recordVideoAction:(UIButton *)sender {
    
    __weak MainViewController *weakSelf = self;

    if ([sender tag] == 0) {
        [sender setTag:1];
        [_mainTopFunctionView setDisableButtons];
        [_argMedia recordVideoStart:^(CGFloat recTime) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[weakSelf mainBottomFunctionView] setRecordTime:recTime];
            });
        }];
    } else if ([sender tag] == 1) {
        [ARGLoading show];
        [sender setTag:0];
        [_mainTopFunctionView setEnableButtons];
        [_argMedia recordVideoStop:^(NSDictionary * _Nonnull videoInfo) {
        } save:^(NSDictionary * _Nonnull videoInfo) {
            [ARGLoading hide];
            
            [self recordVideoFinished:videoInfo];
        }];
    }
}

- (void)takePictureFinished:(UIImage *)image {
    [_argMedia saveImage:image saved:^{
        if ([self isNeedShowAutoSaveMessage]) {
            [[self view] showToast:[@"photo_video_saved_message" localized] position:TOAST_MAIN_POSITION];
        }
    } goToPreview:^{
        [self goPreview:image];
    }];
}

- (void)recordVideoFinished:(NSDictionary *)videoInfo {
    [_argMedia saveVideo:videoInfo saved:^{
        if ([self isNeedShowAutoSaveMessage]) {
            [[self view] showToast:[@"photo_video_saved_message" localized] position:TOAST_MAIN_POSITION];
        }
    } goToPreview:^{
        [self goPreviewVideo:videoInfo];
    }];
}

- (BOOL)isNeedShowAutoSaveMessage {
    if ([[Utils shared] getBoolValue:UTILS_PHOTOSAVE_NEED_SHOW_MESSAGE]) {
        [[Utils shared] setBoolValue:UTILS_PHOTOSAVE_NEED_SHOW_MESSAGE value:NO];
        
        return YES;
    }
    return NO;
}

// MARK: - Touch Lock Control
- (void)touchLock:(BOOL)lock {
    if(!lock) {
        [_touchLockView setHidden:YES];
        [_mainTopFunctionView setEnableButtons];
    } else {
        [_touchLockView setHidden:NO];
        [_mainTopFunctionView setDisableButtons];
    }
}


// MARK: - ARGCamera Delegate
- (void)didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
               fromConnection:(AVCaptureConnection *)connection {

    [_argSession updateSampleBuffer:sampleBuffer fromConnection:connection];
     
    
}

- (void)didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects
                  fromConnection:(AVCaptureConnection *)connection {

    [_argSession updateMetadataObjects:metadataObjects fromConnection:connection];
    
}



// MARK: - ARGearSDK ARGSession delegate

- (void)didUpdateFrame:(ARGFrame *)frame {
    ARGFaces *faces = frame.faces;
    NSArray *faceList = faces.faceList;
    for (ARGFace *face in faceList) {
        if(face.isValid) {
        }
    }
    
    if ([frame renderedPixelBuffer]) {
        [_sceneView displayPixelBuffer:[frame renderedPixelBuffer]];;
    }
}

# pragma mark - Observers
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isEqual:[_settingView autoSaveSwitch]]) {
        // Setting View auto save UISWitch
        if ([keyPath isEqualToString:@"tag"]) {
            NSInteger isOn = [[change objectForKey:@"new"] integerValue];

            [_argMedia setAutoSave:isOn];
        }
    } else if ([object isEqual:[_settingView faceLandmarkSwitch]]) {
        // Setting View show landmark UISWitch
        if ([keyPath isEqualToString:@"tag"]) {
            NSInteger isOn = [[change objectForKey:@"new"] integerValue];

            [_preferences setShowLandmark:isOn];
            
            ARGInferenceDebugOption debugOption = isOn ? ARGInferenceOptionDebugFaceLandmark2D : ARGInferenceOptionDebugNON;
            [_argSession setInferenceDebugOption:debugOption];
        }
    } else if ([object isEqual:[_settingView bitrateSegmentedControl]]) {
        // Setting View bitrate UISegmentedControl
        if ([keyPath isEqualToString:@"tag"]) {
            NSInteger segmentIndex = [[change objectForKey:@"new"] integerValue];
            
            [_preferences setVideoBitrate:segmentIndex];
            [_argMedia setVideoBitrate:(ARGMediaVideoBitrate)segmentIndex];
        }
    }
    
}

@end
