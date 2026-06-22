//
//  TTGDemoReorderTagsViewController.m
//

#import "TTGDemoReorderTagsViewController.h"
#import "TTGDemoUI.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoReorderTagsViewController () <TTGTextTagCollectionViewDelegate>
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@property (nonatomic, strong) UILabel *logLabel;
@property (nonatomic, strong) UISwitch *deleteSwitch;
@end

@implementation TTGDemoReorderTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TTGDemoUI applyScreenBackground:self.view];
    [self setupSubviews];
    [self populateTags];
}

- (void)setupSubviews {
    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Reorder & delete"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Long-press a tag, drag to reorder, or release it over the delete zone."];

    self.tagView = [TTGTextTagCollectionView new];
    self.tagView.delegate = self;
    self.tagView.enableTagSelection = NO;
    self.tagView.enableTagReordering = YES;
    self.tagView.enableDragToDelete = YES;
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.horizontalSpacing = 8;
    self.tagView.verticalSpacing = 8;
    self.tagView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.tagView.dragDeleteZoneHeight = 52;
    self.tagView.dragDeleteZoneInsets = UIEdgeInsetsMake(0, 18, 12, 18);
    self.tagView.dragDeleteZoneCornerRadius = 16;
    self.tagView.dragDeleteZoneBackgroundColor = [UIColor.systemGrayColor colorWithAlphaComponent:0.92];
    self.tagView.dragDeleteZoneHighlightedBackgroundColor = [UIColor.systemPinkColor colorWithAlphaComponent:0.96];
    self.tagView.dragDeleteZoneText = @"Drop tag to remove";
    self.tagView.dragDeleteZoneImage = [UIImage systemImageNamed:@"trash.fill"];
    [TTGDemoUI styleTagSurface:self.tagView];

    UILabel *switchLabel = [TTGDemoUI sectionLabel:@"Drag-to-delete"];
    self.deleteSwitch = [UISwitch new];
    self.deleteSwitch.on = YES;
    [self.deleteSwitch addTarget:self action:@selector(toggleDelete) forControlEvents:UIControlEventValueChanged];
    UIStackView *switchRow = [[UIStackView alloc] initWithArrangedSubviews:@[ switchLabel, self.deleteSwitch ]];
    switchRow.axis = UILayoutConstraintAxisHorizontal;
    switchRow.alignment = UIStackViewAlignmentCenter;
    switchRow.distribution = UIStackViewDistributionEqualSpacing;

    self.logLabel = [UILabel new];
    [TTGDemoUI styleLogLabel:self.logLabel];
    self.logLabel.text = @"Move tags to update order. Drag to the delete zone to remove.";

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[
        titleLabel,
        descriptionLabel,
        self.tagView,
        switchRow,
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
        @"Design", @"Swift", @"UIKit", @"Layout", @"Reusable", @"Fast", @"Docs",
        @"Tests", @"CocoaPods", @"SPM", @"Accessibility", @"Release",
    ];

    NSMutableArray<TTGTextTag *> *tags = [NSMutableArray arrayWithCapacity:words.count];
    for (NSString *word in words) {
        TTGTextTag *tag = [TTGDemoUI tagWithText:word];
        tag.enableAutoDetectAccessibility = YES;
        [tags addObject:tag];
    }

    [self.tagView addTags:tags];
    [self.tagView reload];
}

- (void)toggleDelete {
    self.tagView.enableDragToDelete = self.deleteSwitch.isOn;
    self.logLabel.text = self.deleteSwitch.isOn
        ? @"Drag-to-delete enabled."
        : @"Drag-to-delete disabled. Reordering is still enabled.";
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)collectionView
                   didMoveTag:(TTGTextTag *)tag
                    fromIndex:(NSInteger)fromIndex
                      toIndex:(NSInteger)toIndex {
    NSString *title = [tag.content getContentAttributedString].string;
    self.logLabel.text = [NSString stringWithFormat:@"Moved %@ from %@ to %@.", title, @(fromIndex), @(toIndex)];
}

- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)collectionView
                 canDeleteTag:(TTGTextTag *)tag
                      atIndex:(NSInteger)index {
    return collectionView.allTags.count > 1;
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)collectionView
                 didDeleteTag:(TTGTextTag *)tag
                      atIndex:(NSInteger)index {
    NSString *title = [tag.content getContentAttributedString].string;
    self.logLabel.text = [NSString stringWithFormat:@"Deleted %@ at index %@.", title, @(index)];
}

@end
