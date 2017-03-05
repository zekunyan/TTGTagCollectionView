//
//  TTGExample7ViewController.m
//  TTGTagCollectionView
//
//  Created by tutuge on 2017/3/4.
//  Copyright © 2017年 zekunyan. All rights reserved.
//

#import "TTGExample7ViewController.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface TTGExample7ViewController ()
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
                      @"on", @"constraints", @"placed", @"on", @"those", @"views"];
    
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    config.tagTextFont = [UIFont systemFontOfSize:20];
    
    config.tagTextColor = [UIColor whiteColor];
    config.tagSelectedTextColor = [UIColor whiteColor];
    
    NSUInteger location = 0;
    NSUInteger length = 3;
    config.tagBackgroundColor = [UIColor colorWithRed:0.24 green:0.72 blue:0.94 alpha:1.00];
    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    location += length;
    config.tagBackgroundColor = [UIColor colorWithRed:0.30 green:0.72 blue:0.53 alpha:1.00];
    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    location += length;
    config.tagBackgroundColor = [UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1.00];
    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    location += length;
    config.tagBackgroundColor = [UIColor colorWithRed:0.73 green:0.91 blue:0.41 alpha:1.00];
    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    location += length;
    config.tagBackgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.36 alpha:1.00];
    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    location += length;
    config.tagBackgroundColor = [UIColor colorWithRed:1.00 green:0.41 blue:0.42 alpha:1.00];
    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    location += length;
    config.tagBackgroundColor = [UIColor colorWithRed:0.50 green:0.86 blue:0.90 alpha:1.00];
    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    location += length;
    config.tagBackgroundColor = [UIColor colorWithRed:0.33 green:0.23 blue:0.34 alpha:1.00];
    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
}

@end
