//
//  TTGDemoAnchorLayoutViewController.m
//

#import "TTGDemoAnchorLayoutViewController.h"
#import "TTGDemoUI.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoAnchorLayoutViewController ()
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@end

@implementation TTGDemoAnchorLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self setupTagView];
    [self populateTags];
}

#pragma mark - Setup

- (void)setupTagView {
    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Anchor constraint layout"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Pins the tag view with NSLayoutAnchor constraints. No fixed height is supplied; intrinsicContentSize drives the final layout."];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];
    [self.view addSubview:descriptionLabel];

    self.tagView = [TTGTextTagCollectionView new];
    self.tagView.translatesAutoresizingMaskIntoConstraints = NO;
    [TTGDemoUI styleTagSurface:self.tagView];
    self.tagView.horizontalSpacing = 8;
    self.tagView.verticalSpacing = 8;
    self.tagView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    [self.view addSubview:self.tagView];

    // Pin to safe area with anchors — height is auto-calculated via intrinsicContentSize
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16],
        [titleLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:16],
        [titleLabel.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-16],

        [descriptionLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        [descriptionLabel.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:16],
        [descriptionLabel.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-16],

        [self.tagView.topAnchor constraintEqualToAnchor:descriptionLabel.bottomAnchor constant:18],
        [self.tagView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:16],
        [self.tagView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-16],
    ]];
}

#pragma mark - Data

- (void)populateTags {
    NSArray<NSString *> *words = [TTGTagSampleData shortSampleWords];
    NSArray<UIColor *> *colors = @[
        UIColor.systemBlueColor, UIColor.systemGreenColor,
        UIColor.systemOrangeColor, UIColor.systemPurpleColor, UIColor.systemPinkColor
    ];

    for (NSUInteger i = 0; i < words.count; i++) {
        TTGTextTagStringContent *content = [TTGTextTagStringContent contentWithText:words[i]];
        content.textFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        content.textColor = UIColor.whiteColor;

        TTGTextTagStyle *style = [TTGTextTagStyle new];
        style.backgroundColor = colors[i % colors.count];
        style.cornerRadius = 14;
        style.extraSpace = CGSizeMake(12, 6);

        TTGTextTag *tag = [TTGTextTag tagWithContent:content style:style];
        [self.tagView addTag:tag];
    }

    [self.tagView reload];
}

@end
