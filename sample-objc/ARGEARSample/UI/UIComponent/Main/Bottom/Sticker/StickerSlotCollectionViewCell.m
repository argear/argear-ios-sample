//
//  StickerSlotCollectionViewCell.m
//  ARGEARSample
//
//  Created by Jihye on 02/10/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "StickerSlotCollectionViewCell.h"

@implementation StickerSlotCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)checked {
    [_stickerCheckImage setHidden:NO];
}

- (void)unchecked {
    [_stickerCheckImage setHidden:YES];
}

- (void)setData:(Item *)item {
    
    [_stickerImage sd_setImageWithURL:[NSURL URLWithString:[item thumbnail]] placeholderImage:nil options:SDWebImageRefreshCached];
}

@end
