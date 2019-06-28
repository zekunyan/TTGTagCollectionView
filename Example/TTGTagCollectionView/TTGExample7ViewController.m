//
//  TTGExample7ViewController.m
//  TTGTagCollectionView
//
//  Created by zekunyan on 2017/3/4.
//  Copyright (c) 2019 zekunyan. All rights reserved.
//

#import "TTGExample7ViewController.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface TTGExample7ViewController () <TTGTextTagCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
@end

@implementation TTGExample7ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *tags = @[@"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views"];
    
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
//    TTGTextTag *config = [TTGTextTag new];
//    config.textFont = [UIFont systemFontOfSize:20];
//
//    config.textColor = [UIColor whiteColor];
//    config.selectedTextColor = [UIColor whiteColor];
//
//    NSUInteger location = 0;
//    NSUInteger length = 8;
//    config.backgroundColor = [UIColor colorWithRed:0.24 green:0.72 blue:0.94 alpha:1.00];
//    config.textFont = [UIFont systemFontOfSize:22];
//    config.extraData = @{@"key": @"1"};
//    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
//
//    location += length;
//    config.backgroundColor = [UIColor colorWithRed:0.30 green:0.72 blue:0.53 alpha:1.00];
//    config.textFont = [UIFont systemFontOfSize:22];
//    config.extraData = @{@"key": @"2"};
//    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
//
//    location += length;
//    config.backgroundColor = [UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1.00];
//    config.textFont = [UIFont systemFontOfSize:22];
//    config.extraData = @{@"key": @"3"};
//    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
//
//    location += length;
//    config.backgroundColor = [UIColor colorWithRed:0.73 green:0.91 blue:0.41 alpha:1.00];
//    config.textFont = [UIFont systemFontOfSize:22];
//    config.extraData = @{@"key": @"4"};
//    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
//
//    location += length;
//    config.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.36 alpha:1.00];
//    config.textFont = [UIFont systemFontOfSize:22];
//    config.extraData = @{@"key": @"5"};
//    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
//
//    location += length;
//    config.backgroundColor = [UIColor colorWithRed:1.00 green:0.41 blue:0.42 alpha:1.00];
//    config.textFont = [UIFont systemFontOfSize:22];
//    config.extraData = @{@"key": @"6"};
//    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
//
//    location += length;
//    config.backgroundColor = [UIColor colorWithRed:0.50 green:0.86 blue:0.90 alpha:1.00];
//    config.textFont = [UIFont systemFontOfSize:22];
//    config.extraData = @{@"key": @"7"};
//    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
//
//    location += length;
//    config.backgroundColor = [UIColor colorWithRed:0.33 green:0.23 blue:0.34 alpha:1.00];
//    config.textFont = [UIFont systemFontOfSize:22];
//    config.extraData = @{@"key": @"8"};
//    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    _tagView.delegate = self;
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    NSLog(@"Did tap: %@, config extra: %@", tag.content, tag.attachment);
}

@end
