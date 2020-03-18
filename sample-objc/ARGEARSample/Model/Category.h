//
//  Category.h
//  ARGEARSample
//
//  Created by Jihye on 10/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface Category : RLMObject
// api
@property NSString *uuid;
@property NSString *parentCategoryUuid;
@property NSString *title;
@property NSString *c_description;
@property NSInteger slot_no;
@property NSInteger division;
@property NSInteger is_bundle;
@property NSInteger level;
@property NSString *status;
@property NSInteger updated_at;
@property RLMArray<RLMString> *countries;
@property RLMArray<Item> *items;
// local

@end
RLM_ARRAY_TYPE(Category)

NS_ASSUME_NONNULL_END
