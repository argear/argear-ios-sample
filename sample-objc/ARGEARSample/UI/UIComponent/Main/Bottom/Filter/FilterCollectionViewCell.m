//
//  FilterCollectionViewCell.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "FilterCollectionViewCell.h"

#define FILTER_CHECKED_FULLRATIO_COLOR [UIColor whiteColor]
#define FILTER_UNCHECKED_FULLRATIO_COLOR [UIColor colorWithRed:189.0f/255.0f green:189.0f/255.0f blue:189.0f/255.0f alpha:1.0f]
#define FILTER_CHECKED_COLOR [UIColor colorWithRed:97.0f/255.0f green:97.0f/255.0f blue:97.0f/255.0f alpha:1.0f]
#define FILTER_UNCHECKED_COLOR [UIColor colorWithRed:189.0f/255.0f green:189.0f/255.0f blue:189.0f/255.0f alpha:1.0f]

@implementation FilterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)checked {
    [_filterCheckImage setHidden:NO];
}

- (void)unchecked {
    [_filterCheckImage setHidden:YES];
}

- (void)setData:(Item *)item {
    
    [_filterImage sd_setImageWithURL:[NSURL URLWithString:[item thumbnail]] placeholderImage:nil options:SDWebImageRefreshCached];
    [_filterNameLabel setText:[item title]];
}

- (void)setFilterNameLabelColor:(ARGMediaRatio)ratio {
    
    UIColor *textColor = [UIColor clearColor];
    UIColor *shadowColor = [UIColor clearColor];
    
    if (ratio == ARGMediaRatio_16x9) {
        
        textColor = [_filterCheckImage isHidden] ? FILTER_UNCHECKED_FULLRATIO_COLOR : FILTER_CHECKED_FULLRATIO_COLOR;
        shadowColor = [UIColor colorWithRed:97.f/255.f green:97.f/255.f blue:97.f/255.f alpha:1.0];
    } else {
        
        textColor = [_filterCheckImage isHidden] ? FILTER_UNCHECKED_COLOR : FILTER_CHECKED_COLOR;
    }
    
    [_filterNameLabel setTextColor:textColor];

    [[_filterNameLabel layer] setShadowOffset:CGSizeZero];
    [[_filterNameLabel layer] setShadowRadius:1.f];
    [[_filterNameLabel layer] setShadowOpacity:0.5f];
    [[_filterNameLabel layer] setMasksToBounds:NO];
    [[_filterNameLabel layer] setShouldRasterize:YES];
    [[_filterNameLabel layer] setShadowColor:[shadowColor CGColor]];
}

@end
