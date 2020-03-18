//
//  NetworkManager.m
//  ARGEARSample
//
//  Created by Jihye on 10/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetworkManager

+ (NetworkManager *)shared {
    static dispatch_once_t pred;
    static NetworkManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[NetworkManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)connectAPI:(void (^_Nonnull)(BOOL success, NSDictionary * _Nullable data))completionHandler {
    
    NSString *apiUrlString = [NSString stringWithFormat:@"%@%@", API_HOST, API_KEY];
    NSURL *url = [NSURL URLWithString:apiUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"connectAPI error %@", error);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
            
            NSError *jsonError = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            
            if (jsonError) {
                completionHandler(NO, nil);
                return;
            }

            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                completionHandler(YES, (NSDictionary *)jsonObject);
            } else {
                completionHandler(NO, nil);
            }
        }
    }];
    
    [dataTask resume];
}

- (void)downloadItem:(Item *)item
             success:(void (^)(NSString *uuid, NSURL *targetPath))successBlock
                fail:(void (^)(void))failBlock {
    
    NSString *uuid = [item uuid];
    NSString *fileUrl = [item zip_file];
    NSString *type = [item type];
    NSString *title = [item title];
    
    ARGAuthCallback callback;
    
    callback.Success = ^(NSString *url) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

        NSURL *URL = [NSURL URLWithString:url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];

        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *cacheDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                                              inDomain:NSUserDomainMask
                                                                     appropriateForURL:nil
                                                                                create:NO
                                                                                 error:nil];

            return [cacheDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {

            if (error) {
                failBlock();
                return;
            }

            successBlock(uuid, filePath);
        }];

        [downloadTask resume];
    };
    
    callback.Error = ^(ARGStatusCode code) {
        
        [self alertByCode:code];
        failBlock();
    };

    [[_session auth] requestSignedUrlWithUrl:fileUrl itemTitle:title itemType:type completion:callback];
}

- (void)alertByCode:(ARGStatusCode)code {
    
    NSString *errorTitle = @"";
    NSString *errorMessage = @"";
    
    switch (code) {
        case ARGStatusCode_NETWORK_OFFLINE:
            errorTitle = @"Network offline";
            break;
        case ARGStatusCode_NETWORK_TIMEOUT:
            errorTitle = @"Network timeout";
            break;
        case ARGStatusCode_NETWORK_ERROR:
            errorTitle = @"Network error";
            break;
        case ARGStatusCode_INVALID_AUTH:
            errorTitle = @"Invalid auth";
            break;
        default:
            break;
    }
    errorMessage = [NSString stringWithFormat:@"error code %ld", (long)code];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:errorTitle message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:okAction];

    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
