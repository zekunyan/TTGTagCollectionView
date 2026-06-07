//
//  TTGDemoStackViewViewController.m
//

#import "TTGDemoStackViewViewController.h"
#import "TTGDemoUI.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoStackViewViewController ()
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) TTGTextTagCollectionView *topicTagView;
@property (nonatomic, strong) TTGTextTagCollectionView *skillTagView;
@property (nonatomic, strong) TTGTextTagCollectionView *hobbyTagView;
@property (nonatomic, strong) UIView *hobbiesGroup;
@end

@implementation TTGDemoStackViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    [self setupStackView];
    [self setupTagViews];
    [self populateTags];
}

#pragma mark - Setup

- (void)setupStackView {
    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 16;
    self.stackView.alignment = UIStackViewAlignmentFill;
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.stackView];

    [self.stackView addArrangedSubview:[TTGDemoUI titleLabel:@"UIStackView integration"]];
    [self.stackView addArrangedSubview:[TTGDemoUI descriptionLabel:@"Places multiple TTGTextTagCollectionView instances inside a vertical UIStackView. Toggling a section shows how hidden arranged subviews collapse automatically."]];

    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
    ]];
}

- (TTGTextTagCollectionView *)createTagView {
    TTGTextTagCollectionView *tagView = [TTGTextTagCollectionView new];
    [TTGDemoUI styleTagSurface:tagView];
    tagView.horizontalSpacing = 6;
    tagView.verticalSpacing = 6;
    tagView.contentInset = UIEdgeInsetsMake(6, 6, 6, 6);
    return tagView;
}

- (UIStackView *)createGroupWithTitle:(NSString *)title tagView:(TTGTextTagCollectionView *)tagView {
    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];

    UIStackView *groupStack = [[UIStackView alloc] initWithArrangedSubviews:@[label, tagView]];
    groupStack.axis = UILayoutConstraintAxisVertical;
    groupStack.spacing = 6;
    return groupStack;
}

- (void)setupTagViews {
    self.topicTagView = [self createTagView];
    self.skillTagView = [self createTagView];
    self.hobbyTagView = [self createTagView];

    [self.stackView addArrangedSubview:[self createGroupWithTitle:@"Topics" tagView:self.topicTagView]];
    [self.stackView addArrangedSubview:[self createGroupWithTitle:@"Skills" tagView:self.skillTagView]];

    self.hobbiesGroup = [self createGroupWithTitle:@"Hobbies" tagView:self.hobbyTagView];
    [self.stackView addArrangedSubview:self.hobbiesGroup];
}

#pragma mark - Data

- (void)populateTags {
    [self addTagsToView:self.topicTagView
                   tags:@[@"iOS", @"Swift", @"UIKit", @"SwiftUI", @"CoreData"]
                  color:UIColor.systemBlueColor];
    [self addTagsToView:self.skillTagView
                   tags:@[@"Auto Layout", @"StackView", @"GCD", @"ARC", @"Metal", @"Combine"]
                  color:UIColor.systemGreenColor];
    [self addTagsToView:self.hobbyTagView
                   tags:@[@"Photography", @"Hiking", @"Reading", @"Cooking", @"Travel"]
                  color:UIColor.systemOrangeColor];

    [self.topicTagView reload];
    [self.skillTagView reload];
    [self.hobbyTagView reload];

    // Add toggle button to demonstrate isHidden auto-collapse in StackView
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [toggleButton setTitle:@"Toggle Hobbies visibility" forState:UIControlStateNormal];
    [toggleButton addTarget:self action:@selector(toggleHobbies) forControlEvents:UIControlEventTouchUpInside];
    [self.stackView addArrangedSubview:toggleButton];
}

- (void)addTagsToView:(TTGTextTagCollectionView *)tagView
                 tags:(NSArray<NSString *> *)texts
                color:(UIColor *)color {
    for (NSString *text in texts) {
        TTGTextTagStringContent *content = [TTGTextTagStringContent contentWithText:text];
        content.textFont = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        content.textColor = UIColor.whiteColor;

        TTGTextTagStyle *style = [TTGTextTagStyle new];
        style.backgroundColor = color;
        style.cornerRadius = 12;
        style.extraSpace = CGSizeMake(10, 4);

        [tagView addTag:[TTGTextTag tagWithContent:content style:style]];
    }
}

- (void)toggleHobbies {
    self.hobbiesGroup.hidden = !self.hobbiesGroup.hidden;
}

@end
