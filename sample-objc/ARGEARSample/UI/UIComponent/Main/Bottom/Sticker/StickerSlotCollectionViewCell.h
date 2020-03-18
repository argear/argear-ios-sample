//
//  StickerSlotCollectionViewCell.h
//  ARGEARSample
//
//  Created by Jihye on 02/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StickerSlotCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *stickerImage;
@property (weak, nonatomic) IBOutlet UIImageView *stickerCheckImage;

- (void)checked;
- (void)unchecked;
- (void)setData:(Item *)item;

@end

NS_ASSUME_NONNULL_END
