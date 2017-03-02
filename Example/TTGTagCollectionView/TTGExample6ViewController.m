//
//  TTGExample6ViewController.m
//  TTGTagCollectionView
//
//  Created by tutuge on 2017/3/2.
//  Copyright © 2017年 zekunyan. All rights reserved.
//

#import "TTGExample6ViewController.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface TTGExample6ViewController ()
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;

@end

@implementation TTGExample6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *tags = @[@"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views"];
    
    __weak typeof(self) weakSelf = self;
    [_tagView.scrollView addPullToRefreshWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tagView.scrollView.pullToRefreshView stopAnimating];
            [weakSelf.tagView removeAllTags];
            [weakSelf.tagView addTags:tags];
        });
    }];
    
    [_tagView.scrollView addInfiniteScrollingWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tagView.scrollView.infiniteScrollingView stopAnimating];
            [weakSelf.tagView addTags:tags];
        });
    }];
    
    _tagView.scrollView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    _tagView.scrollView.alwaysBounceVertical = YES; // Very important
    [_tagView.scrollView triggerPullToRefresh];
}

@end
