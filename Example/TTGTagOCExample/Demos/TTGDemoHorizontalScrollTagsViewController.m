//
//  TTGDemoHorizontalScrollTagsViewController.m
//

#import "TTGDemoHorizontalScrollTagsViewController.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoHorizontalScrollTagsViewController ()
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *oneLineTagView;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *twoLineTagView;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *threeLineTagView;
@end

@implementation TTGDemoHorizontalScrollTagsViewController

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
    }
    self.oneLineTagView.numberOfLines = 1;
    self.twoLineTagView.numberOfLines = 2;
    self.threeLineTagView.numberOfLines = 3;
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
        TTGTextTag *t = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:word]
                                             style:[TTGTextTagStyle new]];
        t.selectedStyle.backgroundColor = [UIColor greenColor];
        [tags addObject:t];
    }
    return tags;
}

@end
