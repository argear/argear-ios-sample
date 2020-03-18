//
//  Permission.m
//  ARGEARSample
//
//  Created by Jihye on 19/08/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "Permission.h"
#import <Photos/Photos.h>

@implementation Permission

- (void)allowCameraAction:(void(^)(void))completionHandler {
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (videoStatus == AVAuthorizationStatusDenied) {
        dispatch_async( dispatch_get_main_queue(), ^{
            completionHandler();
        });
    } else {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async( dispatch_get_main_queue(), ^{
                completionHandler();
            });
        }];
    }
}

- (void)allowLibraryAction:(void(^)(void))completionHandler {
    PHAuthorizationStatus libraryStatus = [PHPhotoLibrary authorizationStatus];
    if (libraryStatus == PHAuthorizationStatusDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler();
        });
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async( dispatch_get_main_queue(), ^{
                BOOL authorizeStatus = (status == PHAuthorizationStatusAuthorized) ? YES : NO;
                completionHandler();
            });
        }];
    }
}

- (void)allowMicAction:(void(^)(void))completionHandler {
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (audioStatus == AVAuthorizationStatusDenied) {
        dispatch_async( dispatch_get_main_queue(), ^{
            completionHandler();
        });
    } else {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async( dispatch_get_main_queue(), ^{
                completionHandler();
            });
        }];
    }
}

- (void)permissionAllAllowAction:(PermissionEndBlock)endedBlock {

    [self allowCameraAction:^{
        [self allowLibraryAction:^{
            [self allowMicAction:^{
                [endedBlock invoke];
            }];
        }];
    }];
}

- (PermissionLevel)getPermissionLevel {
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    PHAuthorizationStatus libraryStatus = [PHPhotoLibrary authorizationStatus];
    
    BOOL videoDetermined = (videoStatus == AVAuthorizationStatusNotDetermined) ? YES : NO;
    BOOL audioDetermined = (audioStatus == AVAuthorizationStatusNotDetermined) ? YES : NO;
    BOOL libraryDetermined = (libraryStatus == AVAuthorizationStatusNotDetermined) ? YES : NO;
    
    BOOL videoAuthorized = (videoStatus == AVAuthorizationStatusAuthorized) ? YES : NO;
    BOOL audioAuthorized = (audioStatus == AVAuthorizationStatusAuthorized) ? YES : NO;
    BOOL libraryAuthorized = (libraryStatus == AVAuthorizationStatusAuthorized) ? YES : NO;
    
    if (videoDetermined || audioDetermined || libraryDetermined) {
        return PermissionLevelNone;
    }
    
    if (videoAuthorized && audioAuthorized && libraryAuthorized) {
        return PermissionLevelGranted;
    }
    
    return PermissionLevelRestricted;
}

- (void)openSettings {
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    } else {
        // Fallback on earlier versions (under iOS 10)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
