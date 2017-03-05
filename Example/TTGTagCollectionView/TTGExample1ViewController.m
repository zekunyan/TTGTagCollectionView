//
//  TTGExample1ViewController.m
//  TTGTagCollectionView
//
//  Created by zorro on 15/12/29.
//  Copyright © 2015年 zekunyan. All rights reserved.
//

#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import "TTGExample1ViewController.h"
#import "SVPullToRefresh.h"

@interface TTGExample1ViewController () <TTGTextTagCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *textTagCollectionView1;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *textTagCollectionView2;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@property (strong, nonatomic) NSArray *tags;
@end

@implementation TTGExample1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Remember to set this to NO
    self.automaticallyAdjustsScrollViewInsets = NO;

    // Init Tags
    _tags = @[
            @"AutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayout",
            @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
            @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
            @"on", @"constraints", @"placed", @"on", @"those", @"views",
            @"For", @"example", @"you", @"can", @"constrain", @"a", @"button",
            @"so", @"that", @"it", @"is", @"horizontally", @"centered", @"with",
            @"an", @"Image", @"view", @"and", @"so", @"that", @"the", @"button’s",
            @"top", @"edge", @"always", @"remains", @"8", @"points", @"below", @"the",
            @"image’s", @"bottom", @"If", @"the", @"image", @"view’s", @"size", @"or",
            @"position", @"changes", @"the", @"button’s", @"position", @"automatically", @"adjusts", @"to", @"match"
    ];

    _logLabel.adjustsFontSizeToFitWidth = YES;
    _textTagCollectionView1.delegate = self;
    _textTagCollectionView2.delegate = self;
    
    _textTagCollectionView1.showsVerticalScrollIndicator = NO;
    _textTagCollectionView2.showsVerticalScrollIndicator = NO;

    // Style1
    TTGTextTagConfig *config = _textTagCollectionView1.defaultConfig;
    
    config.tagTextFont = [UIFont boldSystemFontOfSize:18.0f];
    
    config.tagTextColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagSelectedTextColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    
    config.tagBackgroundColor = [UIColor colorWithRed:0.98 green:0.91 blue:0.43 alpha:1.00];
    config.tagSelectedBackgroundColor = [UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1.00];
    
    _textTagCollectionView1.horizontalSpacing = 6.0;
    _textTagCollectionView1.verticalSpacing = 8.0;
    
    config.tagBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagSelectedBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.tagBorderWidth = 1;
    config.tagSelectedBorderWidth = 1;
    
    config.tagShadowColor = [UIColor blackColor];
    config.tagShadowOffset = CGSizeMake(0, 0.3);
    config.tagShadowOpacity = 0.3f;
    config.tagShadowRadius = 0.5f;
    
    config.tagCornerRadius = 2;

    // Style2
    config = _textTagCollectionView2.defaultConfig;
    
    config.tagTextFont = [UIFont systemFontOfSize:20.0f];
    
    config.tagExtraSpace = CGSizeMake(12, 12);
    
    config.tagTextColor = [UIColor whiteColor];
    config.tagSelectedTextColor = [UIColor whiteColor];
    
    config.tagBackgroundColor = [UIColor colorWithRed:0.10 green:0.53 blue:0.85 alpha:1.00];
    config.tagSelectedBackgroundColor = [UIColor colorWithRed:0.21 green:0.29 blue:0.36 alpha:1.00];
    
    config.tagCornerRadius = 8.0f;
    config.tagSelectedCornerRadius = 4.0f;
    
    config.tagBorderWidth = 0;
    
    config.tagBorderColor = [UIColor whiteColor];
    config.tagSelectedBorderColor = [UIColor whiteColor];
    
    config.tagShadowColor = [UIColor blackColor];
    config.tagShadowOffset = CGSizeMake(0, 1);
    config.tagShadowOpacity = 0.3f;
    config.tagShadowRadius = 2;
    
    _textTagCollectionView2.horizontalSpacing = 8;
    _textTagCollectionView2.verticalSpacing = 8;

    // Set tags
    [_textTagCollectionView1 addTags:_tags];
    [_textTagCollectionView2 addTags:_tags];

    // Init selection
    [_textTagCollectionView1 setTagAtIndex:0 selected:YES];
    [_textTagCollectionView1 setTagAtIndex:4 selected:YES];
    [_textTagCollectionView1 setTagAtIndex:6 selected:YES];
    [_textTagCollectionView1 setTagAtIndex:17 selected:YES];

    [_textTagCollectionView2 setTagAtIndex:0 selected:YES];
    [_textTagCollectionView2 setTagAtIndex:4 selected:YES];
    [_textTagCollectionView2 setTagAtIndex:6 selected:YES];
    [_textTagCollectionView2 setTagAtIndex:17 selected:YES];
    
    // Change alignment
    _textTagCollectionView1.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    // Load data
    [_textTagCollectionView1 reload];
    [_textTagCollectionView2 reload];
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    _logLabel.text = [NSString stringWithFormat:@"Tap tag: %@, at: %ld, selected: %d", tagText, (long) index, selected];
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize {
    NSLog(@"text tag collection: %@ new content size: %@", textTagCollectionView, NSStringFromCGSize(contentSize));
}

@end
