//
//  StickerTitleListScrollView.m
//  ARGEARSample
//
//  Created by Jihye on 10/09/2019.
//  Copyright © 2019 Seerslab. All rights reserved.
//

#import "StickerTitleListScrollView.h"

#define STICKER_TITLE_LIST_SCROLLVIEW_FULLRATIO_DISABLE_BUTTON_TEXTCOLOR [UIColor colorWithRed:224.f/255.f green:224.f/255.f blue:224.f/255.f alpha:1.f]
#define STICKER_TITLE_LIST_SCROLLVIEW_FULLRATIO_ENABLE_BUTTON_TEXTCOLOR [UIColor whiteColor]
#define STICKER_TITLE_LIST_SCROLLVIEW_DISABLE_BUTTON_TEXTCOLOR [UIColor colorWithRed:189.f/255.f green:189.f/255.f blue:189.f/255.f alpha:1.f]
#define STICKER_TITLE_LIST_SCROLLVIEW_ENABLE_BUTTON_TEXTCOLOR [UIColor colorWithRed:97.f/255.f green:97.f/255.f blue:97.f/255.f alpha:1.f]
#define STICKER_TITLE_LIST_SCROLLVIEW_SHADOW_COLOR [UIColor colorWithRed:97.f/255.f green:97.f/255.f blue:97.f/255.f alpha:1.f]

@implementation StickerTitleListScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _selectedIndex = 0;
    
    [self setDelegate:self];
}

- (void)setTitleListArray:(NSArray *)titles {
    
    _titleArray = titles;
    
    [self initButtons];
    [self setTitleButtonTextColor];
}

- (void)initButtons {
    
    for (UIButton *button in _titleButtonsArray) {
        [button removeFromSuperview];
    }
    
    _titleButtonsArray = nil;
    _titleButtonsArray = [[NSMutableArray alloc] init];
    
    float pointX = 0;
    for (int i = 0; i < [_titleArray count]; i++) {
        UIFont *font = [UIFont fontWithName:@"NotoSansKR-Regular" size:13.f];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor clearColor]];
        [[button titleLabel] setFont:font];
        [button setTitleColor:STICKER_TITLE_LIST_SCROLLVIEW_DISABLE_BUTTON_TEXTCOLOR forState:UIControlStateNormal];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [button sizeToFit];
        [button setFrame:CGRectMake(pointX, 0, [button frame].size.width + 27.f, 54)];
        [button setTag:i];
        [button addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentView addSubview:button];

        pointX += [button frame].size.width;
        
        [_titleButtonsArray addObject:button];
    }

    [_contentViewWidth setConstant:pointX];
}

- (void)titleButtonAction:(UIButton *)sender {

    [self setSelectedIndex:[NSNumber numberWithInteger:[sender tag]]];
    
    [self setTitleButtonTextColor];
    [self scrollToIndex];
}

- (void)setTitleButtonTextColor {
    
    for (int i = 0; i < [_titleButtonsArray count]; i++) {
        UIButton *button = [_titleButtonsArray objectAtIndex:i];
        
        UIColor *disableColor = [UIColor clearColor];
        UIColor *enableColor = [UIColor clearColor];
        UIColor *shadowColor = [UIColor clearColor];
        
        if ([self tag] == ARGMediaRatio_16x9) {
            
            disableColor = STICKER_TITLE_LIST_SCROLLVIEW_FULLRATIO_DISABLE_BUTTON_TEXTCOLOR;
            enableColor = STICKER_TITLE_LIST_SCROLLVIEW_FULLRATIO_ENABLE_BUTTON_TEXTCOLOR;
            shadowColor = STICKER_TITLE_LIST_SCROLLVIEW_SHADOW_COLOR;
        } else {
            
            disableColor = STICKER_TITLE_LIST_SCROLLVIEW_DISABLE_BUTTON_TEXTCOLOR;
            enableColor = STICKER_TITLE_LIST_SCROLLVIEW_ENABLE_BUTTON_TEXTCOLOR;
        }
        
        UIFont *font = [UIFont fontWithName:@"NotoSansKR-Regular" size:13.f];
        [button setTitleColor:disableColor forState:UIControlStateNormal];
        if (i == [_selectedIndex intValue]) {
            font = [UIFont fontWithName:@"NotoSansKR-Bold" size:13.f];
            
            [button setTitleColor:enableColor forState:UIControlStateNormal];
        }
        
        [[button titleLabel] setFont:font];
        
        [[[button titleLabel] layer] setShadowOffset:CGSizeZero];
        [[[button titleLabel] layer] setShadowRadius:1.f];
        [[[button titleLabel] layer] setShadowOpacity:0.5f];
        [[[button titleLabel] layer] setMasksToBounds:NO];
        [[[button titleLabel] layer] setShouldRasterize:YES];
        [[[button titleLabel] layer] setShadowColor:[shadowColor CGColor]];
    }
}

- (void)scrollToIndex {
    
    UIButton *button = [_titleButtonsArray objectAtIndex:[_selectedIndex intValue]];
    
    float offsetX = [button frame].origin.x - [self frame].size.width/2 + [button frame].size.width/2;
    float right = [self contentSize].width - ([button frame].origin.x + [button frame].size.width);
    float left = [button frame].origin.x - [button frame].size.width/2;

    if (left < [self frame].size.width/2 - [button frame].size.width/2) {
        offsetX = 0;
    } else if (right < ([self frame].size.width/2 - [button frame].size.width/2)) {
        offsetX = [self contentSize].width - [self frame].size.width;
    }
    
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)indexChanged:(NSNumber *)selectedIndex {
    
    _selectedIndex = selectedIndex;

    [self setTitleButtonTextColor];
    [self scrollToIndex];
}

- (void)setRatio:(ARGMediaRatio)ratio {
    
    [self setTag:ratio];
    
    [self setTitleButtonTextColor];
}

@end
