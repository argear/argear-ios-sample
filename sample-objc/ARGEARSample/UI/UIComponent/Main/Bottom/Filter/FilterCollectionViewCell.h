//
//  FilterCollectionViewCell.h
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilterCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *filterImage;
@property (weak, nonatomic) IBOutlet UIImageView *filterCheckImage;
@property (weak, nonatomic) IBOutlet UILabel *filterNameLabel;

- (void)checked;
- (void)unchecked;
- (void)setData:(Item *)item;
- (void)setFilterNameLabelColor:(ARGMediaRatio)ratio;

@end

NS_ASSUME_NONNULL_END
