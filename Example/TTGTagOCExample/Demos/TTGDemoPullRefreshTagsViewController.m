//
//  TTGDemoPullRefreshTagsViewController.m
//

#import "TTGDemoPullRefreshTagsViewController.h"
#import "TTGDemoUI.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface TTGDemoPullRefreshTagsViewController ()
@property (strong, nonatomic) TTGTextTagCollectionView *tagView;
@end

@implementation TTGDemoPullRefreshTagsViewController

- (void)loadView {
    UIView *view = [UIView new];
    [TTGDemoUI applyScreenBackground:view];

    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Pull to refresh"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Integrates TTGTextTagCollectionView's internal scroll view with pull-to-refresh and infinite scrolling. Pull down to replace tags; scroll to the bottom to append more."];
    self.tagView = [TTGTextTagCollectionView new];
    [TTGDemoUI styleTagSurface:self.tagView];
    self.tagView.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    [view addSubview:descriptionLabel];
    [view addSubview:self.tagView];

    UILayoutGuide *safeArea = view.safeAreaLayoutGuide;
    UILayoutGuide *margins = view.layoutMarginsGuide;
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:16],
        [titleLabel.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
        [titleLabel.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],

        [descriptionLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        [descriptionLabel.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
        [descriptionLabel.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],

        [self.tagView.topAnchor constraintEqualToAnchor:descriptionLabel.bottomAnchor constant:18],
        [self.tagView.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
        [self.tagView.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],
        [safeArea.bottomAnchor constraintEqualToAnchor:self.tagView.bottomAnchor constant:16],
    ]];

    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self attachRefreshControls];
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.scrollView.alwaysBounceVertical = YES;
    self.tagView.horizontalSpacing = 8;
    self.tagView.verticalSpacing = 8;
    self.tagView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
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
        TTGTextTag *t = [TTGDemoUI tagWithText:word];
        [tags addObject:t];
    }
    return tags;
}

@end
