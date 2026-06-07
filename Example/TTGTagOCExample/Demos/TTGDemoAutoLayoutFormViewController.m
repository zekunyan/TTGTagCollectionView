//
//  TTGDemoAutoLayoutFormViewController.m
//

#import "TTGDemoAutoLayoutFormViewController.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoAutoLayoutFormViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *formStack;
@property (nonatomic, strong) TTGTextTagCollectionView *interestTagView;
@property (nonatomic, strong) TTGTextTagCollectionView *languageTagView;
@property (nonatomic, strong) UILabel *summaryLabel;
@end

@implementation TTGDemoAutoLayoutFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self setupScrollView];
    [self setupForm];
    [self populateTags];
}

#pragma mark - Setup

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];

    self.formStack = [[UIStackView alloc] init];
    self.formStack.axis = UILayoutConstraintAxisVertical;
    self.formStack.spacing = 20;
    self.formStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.formStack];

    // Pin scroll view to safe area; form stack pinned to scroll view's content layout guide
    UILayoutGuide *contentGuide = self.scrollView.contentLayoutGuide;
    UILayoutGuide *frameGuide = self.scrollView.frameLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.formStack.topAnchor constraintEqualToAnchor:contentGuide.topAnchor constant:20],
        [self.formStack.leadingAnchor constraintEqualToAnchor:frameGuide.leadingAnchor constant:16],
        [self.formStack.trailingAnchor constraintEqualToAnchor:frameGuide.trailingAnchor constant:-16],
        [self.formStack.bottomAnchor constraintEqualToAnchor:contentGuide.bottomAnchor constant:-20],
        [self.formStack.widthAnchor constraintEqualToAnchor:frameGuide.widthAnchor constant:-32],
    ]];
}

- (UILabel *)createSectionTitle:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    return label;
}

- (UILabel *)createSectionDescription:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColor.secondaryLabelColor;
    label.numberOfLines = 0;
    return label;
}

- (TTGTextTagCollectionView *)createTagView {
    TTGTextTagCollectionView *tagView = [TTGTextTagCollectionView new];
    tagView.backgroundColor = UIColor.systemGray6Color;
    tagView.layer.cornerRadius = 8;
    tagView.horizontalSpacing = 6;
    tagView.verticalSpacing = 6;
    tagView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    return tagView;
}

- (void)setupForm {
    // Section 1: Interests
    [self.formStack addArrangedSubview:[self createSectionTitle:@"Your Interests"]];
    [self.formStack addArrangedSubview:[self createSectionDescription:@"Tap tags to select your interests. Height adjusts automatically."]];
    self.interestTagView = [self createTagView];
    self.interestTagView.enableTagSelection = YES;
    [self.formStack addArrangedSubview:self.interestTagView];

    // Separator
    UIView *sep1 = [[UIView alloc] init];
    sep1.backgroundColor = UIColor.separatorColor;
    [sep1.heightAnchor constraintEqualToConstant:1].active = YES;
    [self.formStack addArrangedSubview:sep1];

    // Section 2: Languages
    [self.formStack addArrangedSubview:[self createSectionTitle:@"Programming Languages"]];
    [self.formStack addArrangedSubview:[self createSectionDescription:@"Select languages you know. Tags auto-size and wrap."]];
    self.languageTagView = [self createTagView];
    self.languageTagView.enableTagSelection = YES;
    [self.formStack addArrangedSubview:self.languageTagView];

    // Separator
    UIView *sep2 = [[UIView alloc] init];
    sep2.backgroundColor = UIColor.separatorColor;
    [sep2.heightAnchor constraintEqualToConstant:1].active = YES;
    [self.formStack addArrangedSubview:sep2];

    // Summary
    [self.formStack addArrangedSubview:[self createSectionTitle:@"Selection Summary"]];
    self.summaryLabel = [UILabel new];
    self.summaryLabel.font = [UIFont systemFontOfSize:14];
    self.summaryLabel.textColor = UIColor.labelColor;
    self.summaryLabel.numberOfLines = 0;
    self.summaryLabel.text = @"Tap tags above to see selections here.";
    [self.formStack addArrangedSubview:self.summaryLabel];
}

#pragma mark - Data

- (void)populateTags {
    // Interests
    NSArray<NSString *> *interests = @[
        @"Photography", @"Hiking", @"Reading", @"Cooking", @"Travel",
        @"Music", @"Gaming", @"Fitness", @"Art", @"Writing"
    ];
    for (NSString *text in interests) {
        TTGTextTagStringContent *content = [TTGTextTagStringContent contentWithText:text];
        content.textFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        content.textColor = UIColor.whiteColor;

        TTGTextTagStringContent *selectedContent = [TTGTextTagStringContent contentWithText:text];
        selectedContent.textFont = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        selectedContent.textColor = UIColor.whiteColor;

        TTGTextTagStyle *style = [TTGTextTagStyle new];
        style.backgroundColor = UIColor.systemGray3Color;
        style.cornerRadius = 14;
        style.extraSpace = CGSizeMake(12, 6);

        TTGTextTagStyle *selectedStyle = [TTGTextTagStyle new];
        selectedStyle.backgroundColor = UIColor.systemBlueColor;
        selectedStyle.cornerRadius = 14;
        selectedStyle.extraSpace = CGSizeMake(12, 6);

        TTGTextTag *tag = [TTGTextTag tagWithContent:content style:style selectedContent:selectedContent selectedStyle:selectedStyle];
        tag.onSelectStateChanged = ^(BOOL selected) {
            [self updateSummary];
        };
        [self.interestTagView addTag:tag];
    }
    [self.interestTagView reload];

    // Languages
    NSArray<NSString *> *languages = @[
        @"Swift", @"Kotlin", @"Dart", @"Rust", @"Go", @"Python",
        @"TypeScript", @"Java", @"C++", @"Ruby", @"PHP", @"Scala"
    ];
    for (NSString *text in languages) {
        TTGTextTagStringContent *content = [TTGTextTagStringContent contentWithText:text];
        content.textFont = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        content.textColor = UIColor.whiteColor;

        TTGTextTagStringContent *selectedContent = [TTGTextTagStringContent contentWithText:text];
        selectedContent.textFont = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
        selectedContent.textColor = UIColor.whiteColor;

        TTGTextTagStyle *style = [TTGTextTagStyle new];
        style.backgroundColor = UIColor.systemGray3Color;
        style.cornerRadius = 12;
        style.extraSpace = CGSizeMake(10, 4);

        TTGTextTagStyle *selectedStyle = [TTGTextTagStyle new];
        selectedStyle.backgroundColor = UIColor.systemGreenColor;
        selectedStyle.cornerRadius = 12;
        selectedStyle.extraSpace = CGSizeMake(10, 4);

        TTGTextTag *tag = [TTGTextTag tagWithContent:content style:style selectedContent:selectedContent selectedStyle:selectedStyle];
        tag.onSelectStateChanged = ^(BOOL selected) {
            [self updateSummary];
        };
        [self.languageTagView addTag:tag];
    }
    [self.languageTagView reload];
}

- (void)updateSummary {
    NSArray<TTGTextTag *> *selectedInterests = [self.interestTagView allSelectedTags];
    NSArray<TTGTextTag *> *selectedLanguages = [self.languageTagView allSelectedTags];

    NSMutableArray<NSString *> *interestNames = [NSMutableArray array];
    for (TTGTextTag *tag in selectedInterests) {
        TTGTextTagStringContent *content = (TTGTextTagStringContent *)tag.content;
        [interestNames addObject:content.text];
    }

    NSMutableArray<NSString *> *langNames = [NSMutableArray array];
    for (TTGTextTag *tag in selectedLanguages) {
        TTGTextTagStringContent *content = (TTGTextTagStringContent *)tag.content;
        [langNames addObject:content.text];
    }

    NSMutableString *summary = [NSMutableString string];
    [summary appendFormat:@"Interests (%lu): %@\n\n", (unsigned long)interestNames.count,
     interestNames.count > 0 ? [interestNames componentsJoinedByString:@", "] : @"None"];
    [summary appendFormat:@"Languages (%lu): %@", (unsigned long)langNames.count,
     langNames.count > 0 ? [langNames componentsJoinedByString:@", "] : @"None"];
    self.summaryLabel.text = summary;
}

@end
