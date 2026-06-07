//
//  TTGDemoAttributedStringTagsViewController.m
//

#import "TTGDemoAttributedStringTagsViewController.h"
#import "TTGDemoAttributedTagExamples.h"
#import "TTGDemoUI.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoAttributedStringTagsViewController () <TTGTextTagCollectionViewDelegate>
@property (strong, nonatomic) TTGTextTagCollectionView *textTag;
@end

@implementation TTGDemoAttributedStringTagsViewController

- (void)loadView {
    UIView *view = [UIView new];
    [TTGDemoUI applyScreenBackground:view];

    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Attributed string tags"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Uses TextTagAttributedStringContent to render mixed fonts, colors, decorations, attachments, paragraph styles, and selectable attributed text."];
    self.textTag = [TTGTextTagCollectionView new];
    [TTGDemoUI styleTagSurface:self.textTag];
    self.textTag.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    [view addSubview:descriptionLabel];
    [view addSubview:self.textTag];

    UILayoutGuide *safeArea = view.safeAreaLayoutGuide;
    UILayoutGuide *margins = view.layoutMarginsGuide;
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:16],
        [titleLabel.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
        [titleLabel.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],

        [descriptionLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        [descriptionLabel.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
        [descriptionLabel.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],

        [self.textTag.topAnchor constraintEqualToAnchor:descriptionLabel.bottomAnchor constant:18],
        [self.textTag.leadingAnchor constraintEqualToAnchor:margins.leadingAnchor],
        [self.textTag.trailingAnchor constraintEqualToAnchor:margins.trailingAnchor],
        [safeArea.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.textTag.bottomAnchor constant:16],
    ]];

    self.view = view;
}

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
    self.textTag.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
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
