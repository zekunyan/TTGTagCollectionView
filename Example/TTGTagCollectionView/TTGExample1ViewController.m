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
    
    _textTagCollectionView1.showsVerticalScrollIndicator = NO;
    _textTagCollectionView2.showsVerticalScrollIndicator = NO;

    _textTagCollectionView1.horizontalSpacing = 6.0;
    _textTagCollectionView1.verticalSpacing = 8.0;

    _textTagCollectionView2.horizontalSpacing = 8;
    _textTagCollectionView2.verticalSpacing = 8;

    // Change alignment
    _textTagCollectionView1.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    _textTagCollectionView2.alignment = TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine;

    // Style1
    TTGTextTagStringContent *content = [TTGTextTagStringContent new];
    TTGTextTagStringContent *selectedContent = [TTGTextTagStringContent new];
    TTGTextTagStyle *style = [TTGTextTagStyle new];
    TTGTextTagStyle *selectedStyle = [TTGTextTagStyle new];
    
    content.textFont = [UIFont boldSystemFontOfSize:18.0f];
    selectedContent.textFont = content.textFont;
    
    content.textColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.00];
    selectedContent.textColor = [UIColor whiteColor];
    
    style.backgroundColor = [UIColor colorWithRed:0.31 green:0.70 blue:0.80 alpha:1.00];
    selectedStyle.backgroundColor = [UIColor colorWithRed:0.38 green:0.36 blue:0.63 alpha:1.00];
    
    style.borderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    style.borderWidth = 1;

    selectedStyle.borderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1.00];
    selectedStyle.borderWidth = 1;
    
    style.shadowColor = [UIColor grayColor];
    style.shadowOffset = CGSizeMake(0, 1);
    style.shadowOpacity = 0.5f;
    style.shadowRadius = 2;

    selectedStyle.shadowColor = [UIColor greenColor];
    selectedStyle.shadowOffset = CGSizeMake(0, 2);
    selectedStyle.shadowOpacity = 0.5f;
    selectedStyle.shadowRadius = 1;

    style.cornerRadius = 2;
    selectedStyle.cornerRadius = 4;
    
    style.extraSpace = CGSizeMake(4, 4);
    selectedStyle.extraSpace = style.extraSpace;

    NSMutableArray *tags = [NSMutableArray new];
    for (NSString *string in _tags) {
        TTGTextTagStringContent *stringContent = [content copy];
        stringContent.text = string;
        TTGTextTagStringContent *selectedStringContent = [selectedContent copy];
        selectedStringContent.text = string;
        TTGTextTag *tag = [TTGTextTag new];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = style;
        tag.selectedStyle = selectedStyle;
        [tags addObject:tag.copy];
    }
    [_textTagCollectionView1 addTags:tags];

    // Style2
    content.textFont = [UIFont systemFontOfSize:18.0f];
    selectedContent.textFont = [UIFont systemFontOfSize:20.0f];

    content.textColor = [UIColor whiteColor];
    selectedContent.textColor = [UIColor greenColor];

    style.extraSpace = CGSizeMake(12, 12);
    selectedStyle.extraSpace = CGSizeMake(12, 12);
    
    style.backgroundColor = [UIColor colorWithRed:0.10 green:0.53 blue:0.85 alpha:1.00];
    selectedStyle.backgroundColor = [UIColor colorWithRed:0.21 green:0.29 blue:0.36 alpha:1.00];
    
    style.cornerRadius = 12.0f;
    style.cornerBottomRight = true;
    style.cornerBottomLeft = false;
    style.cornerTopRight = false;
    style.cornerTopLeft = true;

    selectedStyle.cornerRadius = 8.0f;
    selectedStyle.cornerBottomRight = true;
    selectedStyle.cornerBottomLeft = false;
    selectedStyle.cornerTopRight = true;
    selectedStyle.cornerTopLeft = false;
    
    style.borderWidth = 1;
    selectedStyle.borderWidth = 4;
    
    style.borderColor = [UIColor redColor];
    selectedStyle.borderColor = [UIColor orangeColor];

    style.shadowColor = [UIColor blackColor];
    style.shadowOffset = CGSizeMake(0, 4);
    style.shadowOpacity = 0.3f;
    style.shadowRadius = 4;

    selectedStyle.shadowColor = [UIColor redColor];
    selectedStyle.shadowOffset = CGSizeMake(0, 1);
    selectedStyle.shadowOpacity = 0.3f;
    selectedStyle.shadowRadius = 2;

    tags = [NSMutableArray new];
    for (NSString *string in _tags) {
        TTGTextTagStringContent *stringContent = [content copy];
        stringContent.text = string;
        TTGTextTagStringContent *selectedStringContent = [selectedContent copy];
        selectedStringContent.text = [string stringByAppendingString:@"!"];
        TTGTextTag *tag = [TTGTextTag new];
        tag.content = stringContent;
        tag.selectedContent = selectedStringContent;
        tag.style = style;
        tag.selectedStyle = selectedStyle;
        [tags addObject:tag.copy];
    }
    [_textTagCollectionView2 addTags:tags];

    // Init selection
    [_textTagCollectionView1 updateTagAtIndex:0 selected:YES];
    [_textTagCollectionView1 updateTagAtIndex:4 selected:YES];
    [_textTagCollectionView1 updateTagAtIndex:6 selected:YES];
    [_textTagCollectionView1 updateTagAtIndex:17 selected:YES];

    [_textTagCollectionView2 updateTagAtIndex:0 selected:YES];
    [_textTagCollectionView2 updateTagAtIndex:4 selected:YES];
    [_textTagCollectionView2 updateTagAtIndex:6 selected:YES];
    [_textTagCollectionView2 updateTagAtIndex:17 selected:YES];
    
    // Load data
    [_textTagCollectionView1 reload];
    [_textTagCollectionView2 reload];
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected tagConfig:(TTGTextTag *)config {
    _logLabel.text = [NSString stringWithFormat:@"Tap tag: %@, at: %ld, selected: %d", tagText, (long) index, selected];
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize {
    NSLog(@"text tag collection: %@ new content size: %@", textTagCollectionView, NSStringFromCGSize(contentSize));
}

@end
