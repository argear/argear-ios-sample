//
//  FilterView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "FilterView.h"
#import "FiltersData.h"
#import "FilterManager.h"

@implementation FilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _gradient = [CAGradientLayer layer];
    [_gradient setFrame:[self bounds]];
    [_gradient setColors:@[(id)[_topGradientColor CGColor], (id)[_bottomGradientColor CGColor]]];
    
    UIImage *sliderThumb = [UIImage imageNamed:@"bttnControl.png"];
    [_slider setThumbImage:sliderThumb forState:UIControlStateNormal];
    [_slider setThumbImage:sliderThumb forState:UIControlStateHighlighted];
}

- (void)open {
    [self load];

    [self setHidden:NO];
}

- (void)close {
    [self setHidden:YES];
}

- (void)load {
    __weak FilterView *weakSelf = self;

    FiltersData *data = [[FiltersData alloc] init];
    [data getFiltersData:^(NSArray * _Nonnull filters) {
        [[weakSelf filterCollectionView] setFiltersArray:filters];
        [[weakSelf filterCollectionView] reloadData];
    }];
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    if (ratio == ARGMediaRatio_16x9) {

        [[self layer] insertSublayer:_gradient atIndex:0];
        [self setBackgroundColor:[UIColor clearColor]];
    } else {
        
        [_gradient removeFromSuperlayer];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    [_filterCollectionView setRatio:ratio];
}


#pragma mark - UISlider
- (IBAction)sliderValueChanged:(UISlider *)sender {

    [[FilterManager shared] setFilterLevel:[sender value]];
}

@end
