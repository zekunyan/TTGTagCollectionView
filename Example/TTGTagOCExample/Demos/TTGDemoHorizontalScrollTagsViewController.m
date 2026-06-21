//
//  TTGDemoHorizontalScrollTagsViewController.m
//

#import "TTGDemoHorizontalScrollTagsViewController.h"
#import "TTGDemoUI.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoHorizontalScrollTagsViewController ()
@property (strong, nonatomic) TTGTextTagCollectionView *oneLineTagView;
@property (strong, nonatomic) TTGTextTagCollectionView *twoLineTagView;
@property (strong, nonatomic) TTGTextTagCollectionView *threeLineTagView;
@end

@implementation TTGDemoHorizontalScrollTagsViewController

- (void)loadView {
    UIView *view = [UIView new];
    [TTGDemoUI applyScreenBackground:view];

    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Horizontal scroll & line limits"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Horizontal rows use row-major reading order by default. Fixed-height rows can center their content, and legacy column-major distribution remains available."];
    UILabel *oneLineLabel = [TTGDemoUI sectionLabel:@"1 line - row major"];
    UILabel *twoLineLabel = [TTGDemoUI sectionLabel:@"2 lines - row major"];
    UILabel *threeLineLabel = [TTGDemoUI sectionLabel:@"3 lines - legacy column major"];
    self.oneLineTagView = [TTGTextTagCollectionView new];
    self.twoLineTagView = [TTGTextTagCollectionView new];
    self.threeLineTagView = [TTGTextTagCollectionView new];
    [TTGDemoUI styleTagSurface:self.oneLineTagView];
    [TTGDemoUI styleTagSurface:self.twoLineTagView];
    [TTGDemoUI styleTagSurface:self.threeLineTagView];

    NSArray<UIView *> *subviews =
        @[ titleLabel, descriptionLabel, oneLineLabel, self.oneLineTagView,
           twoLineLabel, self.twoLineTagView, threeLineLabel, self.threeLineTagView ];
    for (UIView *subview in subviews) {
        subview.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:subview];
    }

    UILayoutGuide *safeArea = view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:16],
        [titleLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [titleLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],

        [descriptionLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        [descriptionLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [descriptionLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],

        [oneLineLabel.topAnchor constraintEqualToAnchor:descriptionLabel.bottomAnchor constant:18],
        [oneLineLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [oneLineLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],

        [self.oneLineTagView.topAnchor constraintEqualToAnchor:oneLineLabel.bottomAnchor constant:8],
        [self.oneLineTagView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [self.oneLineTagView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],
        [self.oneLineTagView.heightAnchor constraintEqualToConstant:78],

        [twoLineLabel.topAnchor constraintEqualToAnchor:self.oneLineTagView.bottomAnchor constant:16],
        [twoLineLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [twoLineLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],

        [self.twoLineTagView.topAnchor constraintEqualToAnchor:twoLineLabel.bottomAnchor constant:8],
        [self.twoLineTagView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [self.twoLineTagView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],
        [self.twoLineTagView.heightAnchor constraintEqualToConstant:116],

        [threeLineLabel.topAnchor constraintEqualToAnchor:self.twoLineTagView.bottomAnchor constant:16],
        [threeLineLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [threeLineLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],

        [self.threeLineTagView.topAnchor constraintEqualToAnchor:threeLineLabel.bottomAnchor constant:8],
        [self.threeLineTagView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [self.threeLineTagView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],
        [self.threeLineTagView.heightAnchor constraintEqualToConstant:154],
        [safeArea.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.threeLineTagView.bottomAnchor constant:16],
    ]];

    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureScrollAndLineLimits];
    [self loadSameTagsIntoAllRows];
}

#pragma mark - Setup

- (void)configureScrollAndLineLimits {
    NSArray *rows = @[ self.oneLineTagView, self.twoLineTagView, self.threeLineTagView ];
    for (TTGTextTagCollectionView *v in rows) {
        v.scrollDirection = TTGTagCollectionScrollDirectionHorizontal;
        v.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
        v.horizontalDistribution = TTGTagCollectionHorizontalDistributionRowMajor;
        v.contentVerticalAlignment = TTGTagCollectionContentVerticalAlignmentCenter;
        v.horizontalSpacing = 8;
        v.verticalSpacing = 8;
        v.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    self.oneLineTagView.numberOfLines = 1;
    self.twoLineTagView.numberOfLines = 2;
    self.threeLineTagView.numberOfLines = 3;
    self.threeLineTagView.horizontalDistribution = TTGTagCollectionHorizontalDistributionColumnMajor;
}

#pragma mark - Data

- (void)loadSameTagsIntoAllRows {
    NSArray<TTGTextTag *> *tags = [self textTagsFromSampleWords];
    [self.oneLineTagView addTags:tags];
    [self.twoLineTagView addTags:tags];
    [self.threeLineTagView addTags:tags];
    [self.oneLineTagView reload];
    [self.twoLineTagView reload];
    [self.threeLineTagView reload];
}

- (NSArray<TTGTextTag *> *)textTagsFromSampleWords {
    NSMutableArray<TTGTextTag *> *tags = [NSMutableArray array];
    for (NSString *word in [TTGTagSampleData shortSampleWords]) {
        TTGTextTag *t = [TTGDemoUI tagWithText:word];
        [tags addObject:t];
    }
    return tags;
}

@end
