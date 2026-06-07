//
//  TTGDemoBasicTextTagsViewController.m
//

#import "TTGDemoBasicTextTagsViewController.h"
#import "TTGDemoUI.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoBasicTextTagsViewController () <TTGTextTagCollectionViewDelegate>
@property (strong, nonatomic) TTGTextTagCollectionView *textTagCollectionView1;
@property (strong, nonatomic) TTGTextTagCollectionView *textTagCollectionView2;
@property (strong, nonatomic) UILabel *logLabel;

@property (copy, nonatomic) NSArray<NSString *> *sampleWords;
@end

@implementation TTGDemoBasicTextTagsViewController

- (void)loadView {
    UIView *view = [UIView new];
    [TTGDemoUI applyScreenBackground:view];

    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Basic text tags"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Compares two fill alignments with selectable text tags. Tap a tag to inspect selection callbacks below."];
    UILabel *sectionLabel1 = [TTGDemoUI sectionLabel:@"Fill by expanding width"];
    UILabel *sectionLabel2 = [TTGDemoUI sectionLabel:@"Fill except the last line"];
    self.textTagCollectionView1 = [TTGTextTagCollectionView new];
    self.textTagCollectionView2 = [TTGTextTagCollectionView new];
    self.logLabel = [UILabel new];
    [TTGDemoUI styleTagSurface:self.textTagCollectionView1];
    [TTGDemoUI styleTagSurface:self.textTagCollectionView2];
    [TTGDemoUI styleLogLabel:self.logLabel];

    NSArray<UIView *> *subviews =
        @[ titleLabel, descriptionLabel, sectionLabel1, self.textTagCollectionView1,
           sectionLabel2, self.textTagCollectionView2, self.logLabel ];
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

        [sectionLabel1.topAnchor constraintEqualToAnchor:descriptionLabel.bottomAnchor constant:18],
        [sectionLabel1.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [sectionLabel1.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],

        [self.textTagCollectionView1.topAnchor constraintEqualToAnchor:sectionLabel1.bottomAnchor constant:8],
        [self.textTagCollectionView1.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [self.textTagCollectionView1.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],
        [self.textTagCollectionView1.heightAnchor constraintEqualToConstant:210],

        [sectionLabel2.topAnchor constraintEqualToAnchor:self.textTagCollectionView1.bottomAnchor constant:14],
        [sectionLabel2.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [sectionLabel2.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],

        [self.textTagCollectionView2.topAnchor constraintEqualToAnchor:sectionLabel2.bottomAnchor constant:8],
        [self.textTagCollectionView2.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [self.textTagCollectionView2.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],
        [self.textTagCollectionView2.heightAnchor constraintEqualToConstant:170],

        [self.logLabel.topAnchor constraintEqualToAnchor:self.textTagCollectionView2.bottomAnchor constant:14],
        [self.logLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [self.logLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],
        [safeArea.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.logLabel.bottomAnchor constant:12],
    ]];

    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sampleWords = [TTGTagSampleData autoLayoutLongParagraphWords];
    [self configureAppearance];
    [self loadTagsForBothCollections];
    [self applyInitialSelection];
    [self.textTagCollectionView1 reload];
    [self.textTagCollectionView2 reload];
}

#pragma mark - Setup

- (void)configureAppearance {
    self.textTagCollectionView1.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.textTagCollectionView2.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    self.textTagCollectionView1.delegate = self;
    self.textTagCollectionView2.delegate = self;

    self.textTagCollectionView1.showsVerticalScrollIndicator = NO;
    self.textTagCollectionView2.showsVerticalScrollIndicator = NO;

    self.textTagCollectionView1.horizontalSpacing = 6;
    self.textTagCollectionView1.verticalSpacing = 8;
    self.textTagCollectionView1.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.textTagCollectionView2.horizontalSpacing = 8;
    self.textTagCollectionView2.verticalSpacing = 8;
    self.textTagCollectionView2.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);

    self.textTagCollectionView1.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.textTagCollectionView2.alignment = TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine;
}

#pragma mark - Content

- (void)loadTagsForBothCollections {
    [self.textTagCollectionView1 addTags:[self tagsForStyleOne]];
    [self.textTagCollectionView2 addTags:[self tagsForStyleTwo]];
}

- (NSArray<TTGTextTag *> *)tagsForStyleOne {
    TTGTextTagStringContent *content = [TTGTextTagStringContent new];
    TTGTextTagStringContent *selectedContent = [TTGTextTagStringContent new];
    TTGTextTagStyle *style = [TTGTextTagStyle new];
    TTGTextTagStyle *selectedStyle = [TTGTextTagStyle new];

    content.textFont = [UIFont boldSystemFontOfSize:18];
    selectedContent.textFont = content.textFont;
    content.textColor = UIColor.whiteColor;
    selectedContent.textColor = [UIColor whiteColor];

    style.backgroundColor = UIColor.systemBlueColor;
    selectedStyle.backgroundColor = UIColor.systemIndigoColor;

    style.borderWidth = selectedStyle.borderWidth = 0;

    style.shadowOpacity = 0;

    selectedStyle.shadowOpacity = 0;

    style.cornerRadius = selectedStyle.cornerRadius = 14;
    style.extraSpace = selectedStyle.extraSpace = CGSizeMake(12, 6);

    NSMutableArray *tags = [NSMutableArray array];
    for (NSString *word in self.sampleWords) {
        TTGTextTagStringContent *sc = [content copy];
        sc.text = word;
        TTGTextTagStringContent *ssc = [selectedContent copy];
        ssc.text = word;
        TTGTextTag *tag = [TTGTextTag new];
        tag.content = sc;
        tag.selectedContent = ssc;
        tag.style = style;
        tag.selectedStyle = selectedStyle;
        [tags addObject:tag.copy];
    }
    return tags;
}

- (NSArray<TTGTextTag *> *)tagsForStyleTwo {
    TTGTextTagStringContent *content = [TTGTextTagStringContent new];
    TTGTextTagStringContent *selectedContent = [TTGTextTagStringContent new];
    TTGTextTagStyle *style = [TTGTextTagStyle new];
    TTGTextTagStyle *selectedStyle = [TTGTextTagStyle new];

    content.textFont = [UIFont systemFontOfSize:18];
    selectedContent.textFont = [UIFont systemFontOfSize:20];
    content.textColor = [UIColor whiteColor];
    selectedContent.textColor = [UIColor whiteColor];

    style.extraSpace = selectedStyle.extraSpace = CGSizeMake(12, 12);

    style.backgroundColor = UIColor.systemBlueColor;
    selectedStyle.backgroundColor = UIColor.systemIndigoColor;

    style.cornerRadius = 12;
    style.cornerBottomRight = YES;
    style.cornerBottomLeft = NO;
    style.cornerTopRight = NO;
    style.cornerTopLeft = YES;

    selectedStyle.cornerRadius = 8;
    selectedStyle.cornerBottomRight = YES;
    selectedStyle.cornerBottomLeft = NO;
    selectedStyle.cornerTopRight = YES;
    selectedStyle.cornerTopLeft = NO;

    style.borderWidth = 0;
    selectedStyle.borderWidth = 0;
    style.borderColor = UIColor.clearColor;
    selectedStyle.borderColor = UIColor.clearColor;

    style.shadowColor = [UIColor blackColor];
    style.shadowOffset = CGSizeMake(0, 4);
    style.shadowOpacity = 0.3f;
    style.shadowRadius = 4;

    selectedStyle.shadowColor = UIColor.systemIndigoColor;
    selectedStyle.shadowOffset = CGSizeMake(0, 1);
    selectedStyle.shadowOpacity = 0.3f;
    selectedStyle.shadowRadius = 2;

    NSMutableArray *tags = [NSMutableArray array];
    for (NSString *word in self.sampleWords) {
        TTGTextTagStringContent *sc = [content copy];
        sc.text = word;
        TTGTextTagStringContent *ssc = [selectedContent copy];
        ssc.text = [word stringByAppendingString:@"!"];
        TTGTextTag *tag = [TTGTextTag new];
        tag.content = sc;
        tag.selectedContent = ssc;
        tag.style = style;
        tag.selectedStyle = selectedStyle;
        [tags addObject:tag.copy];
    }
    return tags;
}

- (void)applyInitialSelection {
    NSArray *indices = @[@0, @4, @6, @17];
    for (NSNumber *idx in indices) {
        NSInteger i = idx.integerValue;
        [self.textTagCollectionView1 updateTagAtIndex:i selected:YES];
        [self.textTagCollectionView2 updateTagAtIndex:i selected:YES];
    }
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                     didTapTag:(TTGTextTag *)tag
                       atIndex:(NSInteger)index {
    self.logLabel.text =
        [NSString stringWithFormat:@"Tap tag: %@, at: %ld, selected: %d",
                                   tag.content.getContentAttributedString.string,
                                   (long)index,
                                   tag.selected];
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
          updateContentSize:(CGSize)contentSize {
    NSLog(@"TTGTextTagCollectionView %@ contentSize %@", textTagCollectionView, NSStringFromCGSize(contentSize));
}

@end
