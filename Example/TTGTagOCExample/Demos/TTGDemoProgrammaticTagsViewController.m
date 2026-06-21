//
//  TTGDemoProgrammaticTagsViewController.m
//

#import "TTGDemoProgrammaticTagsViewController.h"
#import "TTGDemoUI.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoProgrammaticTagsViewController ()
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@property (nonatomic, strong) UILabel *logLabel;
@property (nonatomic, strong) NSNumber *highlightedTagId;
@property (nonatomic, strong) NSNumber *lastTagId;
@end

@implementation TTGDemoProgrammaticTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TTGDemoUI applyScreenBackground:self.view];
    [self setupTagCollectionViewHierarchy];
    [self populateTagsFromSampleWords];
}

#pragma mark - View hierarchy

- (void)setupTagCollectionViewHierarchy {
    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Programmatic APIs"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Create tags in code, allow selected tags to wrap, update tags by tagId, and scroll directly to a known tag."];

    self.tagView = [TTGTextTagCollectionView new];
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.contentVerticalAlignment = TTGTagCollectionContentVerticalAlignmentCenter;
    self.tagView.horizontalSpacing = 8;
    self.tagView.verticalSpacing = 8;
    self.tagView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [TTGDemoUI styleTagSurface:self.tagView];

    self.tagView.onTapAllArea = ^(CGPoint location) {
        NSLog(@"onTapAllArea: %@", NSStringFromCGPoint(location));
    };
    self.tagView.onTapBlankArea = ^(CGPoint location) {
        NSLog(@"onTapBlankArea: %@", NSStringFromCGPoint(location));
    };

    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectButton setTitle:@"Select by ID" forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectHighlightedTag) forControlEvents:UIControlEventTouchUpInside];
    [TTGDemoUI stylePrimaryButton:selectButton];

    UIButton *scrollButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [scrollButton setTitle:@"Scroll to Last" forState:UIControlStateNormal];
    [scrollButton addTarget:self action:@selector(scrollToLastTag) forControlEvents:UIControlEventTouchUpInside];
    [TTGDemoUI stylePrimaryButton:scrollButton];

    UIStackView *buttonStack = [[UIStackView alloc] initWithArrangedSubviews:@[ selectButton, scrollButton ]];
    buttonStack.axis = UILayoutConstraintAxisHorizontal;
    buttonStack.spacing = 10;
    buttonStack.distribution = UIStackViewDistributionFillEqually;

    self.logLabel = [UILabel new];
    [TTGDemoUI styleLogLabel:self.logLabel];
    self.logLabel.text = @"Use the buttons to update a tag by id or scroll to the last tag.";

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[ titleLabel, descriptionLabel, self.tagView, buttonStack, self.logLabel ]];
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
        [self.tagView.heightAnchor constraintEqualToConstant:170],
    ]];
}

#pragma mark - Data

- (void)populateTagsFromSampleWords {
    NSArray<NSString *> *words = [TTGTagSampleData shortWordsRepeated:2];
    NSMutableArray<TTGTextTag *> *tags = [NSMutableArray array];
    for (NSString *word in words) {
        TTGTextTag *t = [TTGDemoUI tagWithText:word];
        [tags addObject:t];
    }

    TTGTextTag *multilineTag = [TTGDemoUI tagWithText:@"A long selected tag can wrap onto multiple lines when numberOfLines is zero and maxWidth is set"];
    multilineTag.style.numberOfLines = 0;
    multilineTag.style.maxWidth = 220;
    TTGTextTagStyle *selectedStyle = [multilineTag.style copy];
    selectedStyle.backgroundColor = UIColor.systemIndigoColor;
    multilineTag.selectedStyle = selectedStyle;
    [tags insertObject:multilineTag atIndex:3];
    self.highlightedTagId = @(multilineTag.tagId);
    self.lastTagId = @(tags.lastObject.tagId);

    [self.tagView addTags:tags];
    [self.tagView updateTagById:multilineTag.tagId selected:YES];
    [self.tagView reload];
}

#pragma mark - Actions

- (void)selectHighlightedTag {
    if (!self.highlightedTagId) {
        return;
    }
    [self.tagView updateTagById:self.highlightedTagId.integerValue selected:YES];
    self.logLabel.text = [NSString stringWithFormat:@"Selected tag id %@.", self.highlightedTagId];
}

- (void)scrollToLastTag {
    if (!self.lastTagId) {
        return;
    }
    [self.tagView scrollToTagById:self.lastTagId.integerValue position:TTGTagCollectionScrollPositionEnd animated:YES];
    self.logLabel.text = [NSString stringWithFormat:@"Scrolled to tag id %@.", self.lastTagId];
}

@end
