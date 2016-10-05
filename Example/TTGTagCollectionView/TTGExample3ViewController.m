//
//  TTGExample3ViewController.m
//  TTGTagCollectionView
//
//  Created by tutuge on 2016/9/29.
//  Copyright © 2016年 zekunyan. All rights reserved.
//

#import "TTGExample3ViewController.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface TTGExample3ViewController ()
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@end

@implementation TTGExample3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *tags = @[@"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views"];
    
    _tagView = [TTGTextTagCollectionView new];
    _tagView.backgroundColor = [UIColor lightGrayColor];
    _tagView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tagView];
    
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[tagView]-20-|"
                                                                    options:0 metrics:nil
                                                                      views:@{@"tagView": _tagView}];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_tagView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:160];
    
    [self.view addConstraint:topConstraint];
    [self.view addConstraints:hConstraints];
    
    [_tagView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_tagView addTags:tags];
    
    // Random selected
    for (NSInteger i = 0; i < 5; i++) {
        [_tagView setTagAtIndex:arc4random_uniform((uint32_t)tags.count) selected:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_tagView reload];
}

@end
