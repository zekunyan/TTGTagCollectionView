//
//  TTGDemoSelfSizingViewController.m
//

#import "TTGDemoSelfSizingViewController.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoSelfSizingViewController ()
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@property (nonatomic, copy) NSArray<NSString *> *allWords;
@property (nonatomic, assign) NSInteger currentCount;
@end

@implementation TTGDemoSelfSizingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.allWords = [TTGTagSampleData shortSampleWords];
    self.currentCount = 3;
    [self setupUI];
    [self updateTags];
}

#pragma mark - Setup

- (void)setupUI {
    // Title label
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"intrinsicContentSize Demo";
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    titleLabel.textAlignment = NSTextAlignmentCenter;

    // Description label
    UILabel *descLabel = [UILabel new];
    descLabel.text = @"The gray view's height adjusts automatically as tags are added or removed. No manual height calculation.";
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textColor = UIColor.secondaryLabelColor;
    descLabel.numberOfLines = 0;
    descLabel.textAlignment = NSTextAlignmentCenter;

    // Tag view
    self.tagView = [TTGTextTagCollectionView new];
    self.tagView.backgroundColor = UIColor.systemGray6Color;
    self.tagView.layer.cornerRadius = 8;
    self.tagView.horizontalSpacing = 6;
    self.tagView.verticalSpacing = 6;
    self.tagView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);

    // Control buttons
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [addBtn setTitle:@"Add Tag (+)" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [addBtn addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];

    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [removeBtn setTitle:@"Remove Tag (−)" forState:UIControlStateNormal];
    removeBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    [removeBtn addTarget:self action:@selector(removeTag) forControlEvents:UIControlEventTouchUpInside];

    UIStackView *buttonStack = [[UIStackView alloc] initWithArrangedSubviews:@[addBtn, removeBtn]];
    buttonStack.axis = UILayoutConstraintAxisHorizontal;
    buttonStack.distribution = UIStackViewDistributionFillEqually;
    buttonStack.spacing = 16;

    // Arrange everything in a vertical stack
    UIStackView *mainStack = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, descLabel, self.tagView, buttonStack]];
    mainStack.axis = UILayoutConstraintAxisVertical;
    mainStack.spacing = 16;
    [mainStack setCustomSpacing:8 afterView:titleLabel];
    [mainStack setCustomSpacing:24 afterView:descLabel];
    [mainStack setCustomSpacing:24 afterView:self.tagView];
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:mainStack];
    [NSLayoutConstraint activateConstraints:@[
        [mainStack.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [mainStack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [mainStack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
    ]];
}

#pragma mark - Actions

- (void)addTag {
    if (self.currentCount < (NSInteger)self.allWords.count) {
        self.currentCount++;
        [self updateTags];
    }
}

- (void)removeTag {
    if (self.currentCount > 1) {
        self.currentCount--;
        [self updateTags];
    }
}

- (void)updateTags {
    [self.tagView removeAllTags];

    NSArray<NSString *> *words = [self.allWords subarrayWithRange:NSMakeRange(0, self.currentCount)];
    for (NSString *word in words) {
        TTGTextTagStringContent *content = [TTGTextTagStringContent contentWithText:word];
        content.textFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        content.textColor = UIColor.whiteColor;

        TTGTextTagStyle *style = [TTGTextTagStyle new];
        style.backgroundColor = UIColor.systemIndigoColor;
        style.cornerRadius = 14;
        style.extraSpace = CGSizeMake(12, 6);

        [self.tagView addTag:[TTGTextTag tagWithContent:content style:style]];
    }

    // reload() triggers invalidateIntrinsicContentSize internally,
    // so the StackView/Auto Layout picks up the new height automatically.
    [self.tagView reload];
}

@end
