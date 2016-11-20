//
//  TTGExample5ViewController.m
//  TTGTagCollectionView
//
//  Created by tutuge on 2016/10/16.
//  Copyright © 2016年 zekunyan. All rights reserved.
//

#import "TTGExample5ViewController.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface TTGExample5ViewController ()
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *oneLineTagView;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *twoLineTagView;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *threeLineTagView;

@end

@implementation TTGExample5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *tags = @[@"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views"];
    
    _oneLineTagView.scrollDirection = TTGTagCollectionScrollDirectionHorizontal;
    _twoLineTagView.scrollDirection = TTGTagCollectionScrollDirectionHorizontal;
    _threeLineTagView.scrollDirection = TTGTagCollectionScrollDirectionHorizontal;

    _oneLineTagView.numberOfLines = 1;
    _twoLineTagView.numberOfLines = 2;
    _threeLineTagView.numberOfLines = 3;

    [_oneLineTagView addTags:tags];
    [_twoLineTagView addTags:tags];
    [_threeLineTagView addTags:tags];
}

@end
