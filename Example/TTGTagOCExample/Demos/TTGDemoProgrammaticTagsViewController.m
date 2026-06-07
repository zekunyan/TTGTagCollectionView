//
//  TTGDemoProgrammaticTagsViewController.m
//

#import "TTGDemoProgrammaticTagsViewController.h"
#import "TTGDemoUI.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoProgrammaticTagsViewController ()
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
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
    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Programmatic layout & auto height"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Creates TTGTextTagCollectionView entirely in code. The tag view has no fixed height; Auto Layout reads its intrinsicContentSize after reload()."];

    self.tagView = [TTGTextTagCollectionView new];
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
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

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[ titleLabel, descriptionLabel, self.tagView ]];
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
    ]];
}

#pragma mark - Data

- (void)populateTagsFromSampleWords {
    NSArray<NSString *> *words = [TTGTagSampleData shortSampleWords];
    NSMutableArray<TTGTextTag *> *tags = [NSMutableArray array];
    for (NSString *word in words) {
        TTGTextTag *t = [TTGDemoUI tagWithText:word];
        [tags addObject:t];
    }
    [self.tagView addTags:tags];

    for (NSInteger i = 0; i < 5; i++) {
        [self.tagView updateTagAtIndex:arc4random_uniform((uint32_t)words.count) selected:YES];
    }
    [self.tagView reload];
}

@end
