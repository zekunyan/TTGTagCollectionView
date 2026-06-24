//
//  TTGDemoSwipeSelectionTagsViewController.m
//

#import "TTGDemoSwipeSelectionTagsViewController.h"
#import "TTGDemoUI.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoSwipeSelectionTagsViewController () <TTGTextTagCollectionViewDelegate>
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@property (nonatomic, strong) UILabel *logLabel;
@end

@implementation TTGDemoSwipeSelectionTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TTGDemoUI applyScreenBackground:self.view];
    [self setupSubviews];
    [self populateTags];
    [self updateLogWithPrefix:@"No tags selected."];
}

- (void)setupSubviews {
    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Swipe select"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Drag across tags to select multiple items. Tap still toggles one tag at a time."];

    self.tagView = [TTGTextTagCollectionView new];
    self.tagView.delegate = self;
    self.tagView.enableSwipeSelection = YES;
    self.tagView.selectionLimit = 6;
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.horizontalSpacing = 8;
    self.tagView.verticalSpacing = 8;
    self.tagView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [TTGDemoUI styleTagSurface:self.tagView];

    UILabel *limitLabel = [TTGDemoUI sectionLabel:@"Selection limit: 6"];
    UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetSelection) forControlEvents:UIControlEventTouchUpInside];
    [TTGDemoUI stylePrimaryButton:resetButton];

    UIStackView *actionRow = [[UIStackView alloc] initWithArrangedSubviews:@[ limitLabel, resetButton ]];
    actionRow.axis = UILayoutConstraintAxisHorizontal;
    actionRow.alignment = UIStackViewAlignmentCenter;
    actionRow.distribution = UIStackViewDistributionEqualSpacing;

    self.logLabel = [UILabel new];
    [TTGDemoUI styleLogLabel:self.logLabel];

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[
        titleLabel,
        descriptionLabel,
        self.tagView,
        actionRow,
        self.logLabel,
    ]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 12;
    [stack setCustomSpacing:18 afterView:descriptionLabel];
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stack];

    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:20],
        [stack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [stack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.tagView.heightAnchor constraintEqualToConstant:230],
    ]];
}

- (void)populateTags {
    NSArray<NSString *> *words = @[
        @"Travel", @"Food", @"Music", @"Books", @"Fitness", @"Design", @"Swift",
        @"UIKit", @"Photos", @"Family", @"Work", @"Ideas", @"Weekend", @"Learning",
    ];

    NSMutableArray<TTGTextTag *> *tags = [NSMutableArray arrayWithCapacity:words.count];
    for (NSString *word in words) {
        TTGTextTag *tag = [TTGDemoUI tagWithText:word];
        tag.selectedStyle = [TTGDemoUI selectedTagStyleWithColor:UIColor.systemGreenColor];
        [tags addObject:tag];
    }

    [self.tagView addTags:tags];
    [self.tagView reload];
}

- (void)resetSelection {
    for (TTGTextTag *tag in self.tagView.allTags) {
        tag.selected = NO;
    }
    [self.tagView reload];
    [self updateLogWithPrefix:@"Selection reset."];
}

- (void)updateLogWithPrefix:(NSString *)prefix {
    NSMutableArray<NSString *> *titles = [NSMutableArray array];
    for (TTGTextTag *tag in self.tagView.allSelectedTags) {
        [titles addObject:[tag.content getContentAttributedString].string];
    }

    if (titles.count == 0) {
        self.logLabel.text = prefix;
    } else {
        self.logLabel.text = [NSString stringWithFormat:@"%@ Selected: %@", prefix, [titles componentsJoinedByString:@", "]];
    }
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)collectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSInteger)index {
    [self updateLogWithPrefix:[NSString stringWithFormat:@"Tapped index %@.", @(index)]];
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)collectionView
            didSwipeSelectTag:(TTGTextTag *)tag
                      atIndex:(NSInteger)index {
    [self updateLogWithPrefix:[NSString stringWithFormat:@"Swipe selected index %@.", @(index)]];
}

@end
