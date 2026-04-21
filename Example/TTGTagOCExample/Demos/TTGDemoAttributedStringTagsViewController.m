//
//  TTGDemoAttributedStringTagsViewController.m
//

#import "TTGDemoAttributedStringTagsViewController.h"
#import "TTGDemoAttributedTagExamples.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoAttributedStringTagsViewController () <TTGTextTagCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *textTag;
@end

@implementation TTGDemoAttributedStringTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionViewChrome];
    [self installDemonstrationTags];
}

#pragma mark - Setup

- (void)configureCollectionViewChrome {
    self.textTag.delegate = self;
    self.textTag.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.textTag.horizontalSpacing = 8;
    self.textTag.verticalSpacing = 10;
}

#pragma mark - Content (built by TTGDemoAttributedTagExamples)

- (void)installDemonstrationTags {
    for (TTGTextTag *tag in [TTGDemoAttributedTagExamples allDemonstrationTags]) {
        [self.textTag addTag:tag];
    }
    [self.textTag reload];
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSInteger)index {
    NSString *plain = tag.content.getContentAttributedString.string ?: @"";
    NSLog(@"Tap [%ld]: \"%@\" selected: %@", (long)index, plain, tag.selected ? @"YES" : @"NO");
}

@end
