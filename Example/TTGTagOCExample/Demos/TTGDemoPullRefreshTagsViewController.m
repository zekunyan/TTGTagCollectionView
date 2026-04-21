//
//  TTGDemoPullRefreshTagsViewController.m
//

#import "TTGDemoPullRefreshTagsViewController.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface TTGDemoPullRefreshTagsViewController ()
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
@end

@implementation TTGDemoPullRefreshTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self attachRefreshControls];
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.scrollView.alwaysBounceVertical = YES;
    [self.tagView.scrollView triggerPullToRefresh];
}

#pragma mark - Refresh controls

- (void)attachRefreshControls {
    __weak typeof(self) weakSelf = self;

    [self.tagView.scrollView addPullToRefreshWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tagView.scrollView.pullToRefreshView stopAnimating];
            [weakSelf.tagView removeAllTags];
            [weakSelf.tagView addTags:[weakSelf buildSampleTextTags]];
            [weakSelf.tagView reload];
        });
    }];

    [self.tagView.scrollView addInfiniteScrollingWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tagView.scrollView.infiniteScrollingView stopAnimating];
            [weakSelf.tagView addTags:[weakSelf buildSampleTextTags]];
            [weakSelf.tagView reload];
        });
    }];

    self.tagView.scrollView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
}

#pragma mark - Data

- (NSArray<TTGTextTag *> *)buildSampleTextTags {
    NSMutableArray<TTGTextTag *> *tags = [NSMutableArray array];
    for (NSString *word in [TTGTagSampleData shortSampleWords]) {
        TTGTextTag *t = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:word]
                                             style:[TTGTextTagStyle new]];
        t.selectedStyle.backgroundColor = [UIColor greenColor];
        [tags addObject:t];
    }
    return tags;
}

@end
