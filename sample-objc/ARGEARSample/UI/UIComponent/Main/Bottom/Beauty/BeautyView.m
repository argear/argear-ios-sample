//
//  BeautyView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "BeautyView.h"
#import "UIImage+Color.h"
#import "BulgeManager.h"
#import "StickerManager.h"

@implementation BeautyView

#define kBeautyViewCompareIconName @"icCompare"
#define kBeautyViewRefreshIconName @"icRefresh"

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
    [_gradient setColors:@[(id)_topGradientColor.CGColor, (id)_bottomGradientColor.CGColor]];
    
    UIImage *sliderThumb = [UIImage imageNamed:@"bttnControl.png"];
    [_slider setThumbImage:sliderThumb forState:UIControlStateNormal];
    [_slider setThumbImage:sliderThumb forState:UIControlStateHighlighted];
    [_slider setValue:[[BeautyManager shared] getBeautyValue:0]];

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(compareButtonLongPressAction:)];
    [_compareButton addGestureRecognizer:longPressGesture];
    
    [self setButtons:[self tag]];
    [self addObservers];
}

- (void)dealloc {
    [self removeObservers];
}

- (void)open {
    [self setHidden:NO];
    
    [[BulgeManager shared] off];
    [[StickerManager shared] clearSticker];
}

- (void)close {
    [self setHidden:YES];
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    [self setTag:ratio];
    
    if (ratio == ARGMediaRatio_16x9) {

        [[self layer] insertSublayer:_gradient atIndex:0];
        [self setBackgroundColor:[UIColor clearColor]];
    } else {
        
        [_gradient removeFromSuperlayer];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    [self setButtons:ratio];
    
    [_beautyCollectionView setRatio:ratio];
}

- (void)setButtons:(ARGMediaRatio)ratio {

    NSMutableString *compareButtonImageString = [NSMutableString stringWithString:kBeautyViewCompareIconName];
    NSMutableString *refreshButtonImageString = [NSMutableString stringWithString:kBeautyViewRefreshIconName];
    
    if (ratio == ARGMediaRatio_16x9) {
        
        [compareButtonImageString appendString:@"White"];
        [refreshButtonImageString appendString:@"White"];
    } else {
        
        [compareButtonImageString appendString:@"Black"];
        [refreshButtonImageString appendString:@"Black"];
    }
    
    [_compareButton setImage:[UIImage imageNamed:compareButtonImageString] forState:UIControlStateNormal];
    [_compareButton setImage:[[UIImage imageNamed:compareButtonImageString] imageWithAlphaComponent:BUTTON_HIGHLIGHTED_ALPHA] forState:UIControlStateHighlighted];

    [_resetButton setImage:[UIImage imageNamed:refreshButtonImageString] forState:UIControlStateNormal];
    [_resetButton setImage:[[UIImage imageNamed:refreshButtonImageString] imageWithAlphaComponent:BUTTON_HIGHLIGHTED_ALPHA] forState:UIControlStateHighlighted];
}

- (void)addObservers {
    [_beautyCollectionView addObserver:self forKeyPath:@"selectedIndexPath" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObservers {
    [_beautyCollectionView removeObserver:self forKeyPath:@"selectedIndexPath" context:nil];
}

- (void)compareButtonLongPressAction:(UILongPressGestureRecognizer*)gesture {
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        [[BeautyManager shared] off];
    } else if ([gesture state] == UIGestureRecognizerStateEnded) {
        [[BeautyManager shared] on];
    }
}

- (IBAction)resetButtonAction:(UIButton *)sender {
    
    [[BeautyManager shared] setDefault];
    
    NSIndexPath *selectedIndexPath = [_beautyCollectionView selectedIndexPath];
    CGFloat beautyValue = [[BeautyManager shared] getBeautyValue:[selectedIndexPath row]];
    
    [_slider setValue:beautyValue];
}

#pragma mark - UISlider
- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    [[BeautyManager shared] setBeauty:[sender tag] value:[sender value]];
}

# pragma mark - Observers
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([object isKindOfClass:[BeautyCollectionView class]]) {
        
        if ([keyPath isEqualToString:@"selectedIndexPath"]) {
            NSIndexPath *indexPath = [change objectForKey:@"new"];
            
            CGFloat beautyValue = [[BeautyManager shared] getBeautyValue:[indexPath row]];
            [_slider setTag:[indexPath row]];
            [_slider setValue:beautyValue];
        }
    }
}

@end
