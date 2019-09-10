//
//  TTGExample1ViewController.m
//  TTGTagCollectionView
//
//  Created by zorro on 15/12/29.
//  Copyright © 2015年 zekunyan. All rights reserved.
//

#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import "TTGExample1ViewController.h"

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
    _textTagCollectionView1.alignment = TTGTagCollectionAlignmentLeading;
    _textTagCollectionView2.alignment = TTGTagCollectionAlignmentTrailing;
    
    _textTagCollectionView1.layer.borderColor = [UIColor grayColor].CGColor;
    _textTagCollectionView1.layer.borderWidth = 1;
    
    _textTagCollectionView2.layer.borderColor = [UIColor grayColor].CGColor;
    _textTagCollectionView2.layer.borderWidth = 1;
    
    _textTagCollectionView1.showsVerticalScrollIndicator = NO;
    _textTagCollectionView2.showsVerticalScrollIndicator = NO;

    // Style1
    TTGTextTagConfig *config = _textTagCollectionView1.defaultConfig;
    
    config.textFont = [UIFont boldSystemFontOfSize:18.0f];
    
    config.textColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.selectedTextColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    
    config.backgroundColor = [UIColor colorWithRed:0.98 green:0.91 blue:0.43 alpha:1.00];
    config.selectedBackgroundColor = [UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1.00];
    
    _textTagCollectionView1.horizontalSpacing = 6.0;
    _textTagCollectionView1.verticalSpacing = 8.0;
    
    config.borderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.selectedBorderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    config.borderWidth = 1;
    config.selectedBorderWidth = 1;
    
    config.shadowColor = [UIColor blackColor];
    config.shadowOffset = CGSizeMake(0, 0.3);
    config.shadowOpacity = 0.3f;
    config.shadowRadius = 0.5f;
    
    config.cornerRadius = 7;
    
    config.enableGradientBackground = YES;
    config.gradientBackgroundStartColor = [UIColor orangeColor];
    config.selectedGradientBackgroundStartColor = [UIColor yellowColor];
    config.gradientBackgroundEndColor = [UIColor yellowColor];
    config.selectedGradientBackgroundEndColor = [UIColor grayColor];
    config.gradientBackgroundStartPoint =CGPointMake(0, 0);
    config.gradientBackgroundEndPoint = CGPointMake(1, 1);

    // Style2
    config = _textTagCollectionView2.defaultConfig;
    
    config.textFont = [UIFont systemFontOfSize:20.0f];
    
    config.extraSpace = CGSizeMake(12, 12);
    
    config.textColor = [UIColor whiteColor];
    config.selectedTextColor = [UIColor greenColor];
    
    config.backgroundColor = [UIColor colorWithRed:0.10 green:0.53 blue:0.85 alpha:1.00];
    config.selectedBackgroundColor = [UIColor colorWithRed:0.21 green:0.29 blue:0.36 alpha:1.00];
    
    config.cornerRadius = 12.0f;
    config.selectedCornerRadius = 8.0f;
    config.cornerBottomRight = true;
    config.cornerBottomLeft = false;
    config.cornerTopRight = false;
    config.cornerTopLeft = true;
    
    config.borderWidth = 1;
    config.selectedBorderWidth = 4;
    
    config.borderColor = [UIColor redColor];
    config.selectedBorderColor = [UIColor orangeColor];
    
    config.shadowColor = [UIColor blackColor];
    config.shadowOffset = CGSizeMake(0, 1);
    config.shadowOpacity = 0.3f;
    config.shadowRadius = 2;
    
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
    _textTagCollectionView1.alignment = TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine;
    
    // Load data
    [_textTagCollectionView1 reload];
    [_textTagCollectionView2 reload];
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected tagConfig:(TTGTextTagConfig *)config {
    _logLabel.text = [NSString stringWithFormat:@"Tap tag: %@, at: %ld, selected: %d", tagText, (long) index, selected];
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize {
    NSLog(@"text tag collection: %@ new content size: %@", textTagCollectionView, NSStringFromCGSize(contentSize));
}

@end
