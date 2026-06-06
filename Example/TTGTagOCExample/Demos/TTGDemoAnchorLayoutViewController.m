//
//  TTGDemoAnchorLayoutViewController.m
//

#import "TTGDemoAnchorLayoutViewController.h"
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
    self.tagView = [TTGTextTagCollectionView new];
    self.tagView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tagView.backgroundColor = UIColor.systemGray6Color;
    self.tagView.horizontalSpacing = 8;
    self.tagView.verticalSpacing = 8;
    self.tagView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    [self.view addSubview:self.tagView];

    // Pin to safe area with anchors — height is auto-calculated via intrinsicContentSize
    [NSLayoutConstraint activateConstraints:@[
        [self.tagView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
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
