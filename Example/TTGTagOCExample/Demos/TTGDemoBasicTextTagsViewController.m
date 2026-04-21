//
//  TTGDemoBasicTextTagsViewController.m
//

#import "TTGDemoBasicTextTagsViewController.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoBasicTextTagsViewController () <TTGTextTagCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *textTagCollectionView1;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *textTagCollectionView2;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

@property (copy, nonatomic) NSArray<NSString *> *sampleWords;
@end

@implementation TTGDemoBasicTextTagsViewController

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

    self.logLabel.adjustsFontSizeToFitWidth = YES;
    self.textTagCollectionView1.delegate = self;
    self.textTagCollectionView2.delegate = self;

    self.textTagCollectionView1.showsVerticalScrollIndicator = NO;
    self.textTagCollectionView2.showsVerticalScrollIndicator = NO;

    self.textTagCollectionView1.horizontalSpacing = 6;
    self.textTagCollectionView1.verticalSpacing = 8;
    self.textTagCollectionView2.horizontalSpacing = 8;
    self.textTagCollectionView2.verticalSpacing = 8;

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
    content.textColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1];
    selectedContent.textColor = [UIColor whiteColor];

    style.backgroundColor = [UIColor colorWithRed:0.31 green:0.70 blue:0.80 alpha:1];
    selectedStyle.backgroundColor = [UIColor colorWithRed:0.38 green:0.36 blue:0.63 alpha:1];

    style.borderColor = selectedStyle.borderColor = [UIColor colorWithRed:0.18 green:0.19 blue:0.22 alpha:1];
    style.borderWidth = selectedStyle.borderWidth = 1;

    style.shadowColor = [UIColor grayColor];
    style.shadowOffset = CGSizeMake(0, 1);
    style.shadowOpacity = 0.5f;
    style.shadowRadius = 2;

    selectedStyle.shadowColor = [UIColor greenColor];
    selectedStyle.shadowOffset = CGSizeMake(0, 2);
    selectedStyle.shadowOpacity = 0.5f;
    selectedStyle.shadowRadius = 1;

    style.cornerRadius = 2;
    selectedStyle.cornerRadius = 4;
    style.extraSpace = selectedStyle.extraSpace = CGSizeMake(4, 4);

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
    selectedContent.textColor = [UIColor greenColor];

    style.extraSpace = selectedStyle.extraSpace = CGSizeMake(12, 12);

    style.backgroundColor = [UIColor colorWithRed:0.10 green:0.53 blue:0.85 alpha:1];
    selectedStyle.backgroundColor = [UIColor colorWithRed:0.21 green:0.29 blue:0.36 alpha:1];

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

    style.borderWidth = 1;
    selectedStyle.borderWidth = 4;
    style.borderColor = [UIColor redColor];
    selectedStyle.borderColor = [UIColor orangeColor];

    style.shadowColor = [UIColor blackColor];
    style.shadowOffset = CGSizeMake(0, 4);
    style.shadowOpacity = 0.3f;
    style.shadowRadius = 4;

    selectedStyle.shadowColor = [UIColor redColor];
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
