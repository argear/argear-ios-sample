//
//  FiltersData.h
//  ARGEARSample
//
//  Created by Jihye on 14/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FiltersData : NSObject

- (void)getFiltersData:(void (^)(NSArray *filters))completionHandler;

@end

NS_ASSUME_NONNULL_END
