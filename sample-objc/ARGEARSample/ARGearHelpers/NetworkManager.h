//
//  NetworkManager.h
//  ARGEARSample
//
//  Created by Jihye on 10/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARGear/ARGear.h>

NS_ASSUME_NONNULL_BEGIN

// argear sample
#define API_HOST @"https://apis.argear.io/api/v3/"
#define API_KEY @"48cdd456621ebddb5283f516"
#define API_SECRET_KEY @"e0ea29ce12178111d2a5e6093a6e048a2a6248b921f092f68c93992ca29a45ee"
#define API_AUTH_KEY @"U2FsdGVkX19DguB6YrrW+9R193+Jsekcvt38I7dROnYZ7NkmCuCff843TkNC4CWTgYVplAnXjirwOxK/uAGVqQ=="

@interface NetworkManager : NSObject

@property (nonatomic, assign) ARGSession *session;

+ (NetworkManager *)shared;

- (void)connectAPI:(void (^_Nonnull)(BOOL success, NSDictionary * _Nullable data))completionHandler;

- (void)downloadItem:(Item *)item
             success:(void (^)(NSString *uuid, NSURL *targetPath))successBlock
                fail:(void (^)(void))failBlock;
@end

NS_ASSUME_NONNULL_END
