//
//  ARGAuth.h
//  ARGEARSDK
//
//  Created by Jihye on 13/11/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARGSession.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct ARGAuthCallback {
    __unsafe_unretained void (^ _Nullable Success) (NSString * _Nullable url);
    __unsafe_unretained void (^ _Nullable Error) (ARGStatusCode code);
} ARGAuthCallback;

@interface ARGAuth : NSObject

- (BOOL)isValid;
- (void)requestSignedUrlWithUrl:(NSString *)url itemTitle:(NSString *)title itemType:(NSString *)type completion:(ARGAuthCallback)completion;

@end

NS_ASSUME_NONNULL_END
