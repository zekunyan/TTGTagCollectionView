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
            @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
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

    // Style1
    _textTagCollectionView1.tagTextFont = [UIFont boldSystemFontOfSize:22.0f];
    _textTagCollectionView1.horizontalSpacing = 6.0;
    _textTagCollectionView1.verticalSpacing = 12.0;

    // Style2
    _textTagCollectionView2.tagTextFont = [UIFont systemFontOfSize:14.0f];
    _textTagCollectionView2.extraSpace = CGSizeMake(12, 12);
    _textTagCollectionView2.tagTextColor = [UIColor colorWithRed:93 / 256.0f green:64 / 256.0f blue:55 / 256.0f alpha:1];
    _textTagCollectionView2.tagSelectedTextColor = [UIColor colorWithRed:33 / 256.0f green:33 / 256.0f blue:33 / 256.0f alpha:1];
    _textTagCollectionView2.tagBackgroundColor = [UIColor colorWithRed:215 / 256.0f green:204 / 256.0f blue:200 / 256.0f alpha:1];
    _textTagCollectionView2.tagSelectedBackgroundColor = [UIColor colorWithRed:255 / 256.0f green:193 / 256.0f blue:7 / 256.0f alpha:1];
    _textTagCollectionView2.tagCornerRadius = 8.0f;
    _textTagCollectionView2.tagSelectedCornerRadius = 14.0f;
    _textTagCollectionView2.tagBorderWidth = 2.0f;
    _textTagCollectionView2.tagSelectedBorderWidth = 4.0f;
    _textTagCollectionView2.tagBorderColor = [UIColor colorWithRed:33 / 256.0f green:33 / 256.0f blue:33 / 256.0f alpha:1];
    _textTagCollectionView2.tagSelectedBorderColor = [UIColor colorWithRed:93 / 256.0f green:64 / 256.0f blue:55 / 256.0f alpha:1];

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
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    _logLabel.text = [NSString stringWithFormat:@"Tap tag: %@, at: %ld, selected: %d", tagText, (long) index, selected];
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentHeight:(CGFloat)newContentHeight {
    NSLog(@"text tag collection: %@ new content height: %g", textTagCollectionView, newContentHeight);
}

@end
