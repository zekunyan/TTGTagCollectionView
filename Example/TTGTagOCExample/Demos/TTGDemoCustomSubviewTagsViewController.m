//
//  TTGDemoCustomSubviewTagsViewController.m
//

#import "TTGDemoCustomSubviewTagsViewController.h"
#import "TTGDemoUI.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoCustomSubviewTagsViewController () <TTGTagCollectionViewDelegate, TTGTagCollectionViewDataSource>
@property (strong, nonatomic) TTGTagCollectionView *tagCollectionView;
@property (strong, nonatomic) UILabel *logLabel;
@property (strong, nonatomic) NSMutableArray<UIView *> *tagViews;
@property (strong, nonatomic) NSMutableArray<NSValue *> *tagSizes;
@property (assign, nonatomic) BOOL didReloadAfterLayout;
@end

@implementation TTGDemoCustomSubviewTagsViewController

- (void)loadView {
    UIView *view = [UIView new];
    [TTGDemoUI applyScreenBackground:view];

    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Custom UIView tags"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Feeds labels, buttons, and image views through TTGTagCollectionViewDataSource. The collection view measures each custom UIView via sizeForTagAtIndex."];
    self.tagCollectionView = [TTGTagCollectionView new];
    [TTGDemoUI styleTagSurface:self.tagCollectionView];
    self.tagCollectionView.translatesAutoresizingMaskIntoConstraints = NO;

    self.logLabel = [UILabel new];
    [TTGDemoUI styleLogLabel:self.logLabel];

    NSArray<UIView *> *subviews = @[ titleLabel, descriptionLabel, self.tagCollectionView, self.logLabel ];
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

        [self.tagCollectionView.topAnchor constraintEqualToAnchor:descriptionLabel.bottomAnchor constant:18],
        [self.tagCollectionView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [self.tagCollectionView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],
        [self.tagCollectionView.heightAnchor constraintEqualToConstant:320],

        [self.logLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:20],
        [self.logLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-20],
        [safeArea.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.logLabel.bottomAnchor constant:12],
    ]];

    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    self.tagCollectionView.horizontalSpacing = 8;
    self.tagCollectionView.verticalSpacing = 8;
    self.tagCollectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.tagViews = [NSMutableArray array];
    self.tagSizes = [NSMutableArray array];
    [self buildDemoTagViews];
    [self.tagCollectionView reload];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!self.didReloadAfterLayout && self.tagCollectionView.bounds.size.width > 0) {
        self.didReloadAfterLayout = YES;
        [self.tagCollectionView reload];
    }
}

#pragma mark - Demo subviews

- (void)buildDemoTagViews {
    UIColor *teal = UIColor.systemTealColor;
    UIColor *blue = UIColor.systemBlueColor;
    UIColor *orange = UIColor.systemOrangeColor;

    void (^add)(UIView *) = ^(UIView *v) {
        [self.tagViews addObject:v];
        [self.tagSizes addObject:[NSValue valueWithCGSize:v.frame.size]];
    };

    add([self labelWithText:@"AutoLayout" fontSize:14 textColor:UIColor.whiteColor background:teal]);
    add([self buttonWithTitle:@"Button1" fontSize:18 background:blue]);
    add([self imageNamed:@"bluefaces_1"]);
    add([self labelWithText:@"dynamically" fontSize:20 textColor:UIColor.whiteColor background:teal]);
    add([self buttonWithTitle:@"Button2" fontSize:16 background:orange]);
    add([self buttonWithTitle:@"Button3" fontSize:15 background:blue]);
    add([self imageNamed:@"bluefaces_2"]);
    add([self labelWithText:@"the" fontSize:16 textColor:UIColor.whiteColor background:teal]);
    add([self buttonWithTitle:@"Button4" fontSize:22 background:blue]);
    add([self imageNamed:@"bluefaces_3"]);
    add([self labelWithText:@"views" fontSize:12
                  textColor:[UIColor colorWithRed:0.21 green:0.29 blue:0.36 alpha:1]
                 background:orange]);
    add([self buttonWithTitle:@"Button5" fontSize:15 background:teal]);
    add([self imageNamed:@"bluefaces_4"]);
    add([self imageNamed:@"bluefaces_4"]);
}

#pragma mark - TTGTagCollectionViewDelegate

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSInteger)index {
    return self.tagSizes[index].CGSizeValue;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView
         didSelectTag:(UIView *)tagView
               atIndex:(NSInteger)index {
    self.logLabel.text = [NSString stringWithFormat:@"Tap tag: %@, at: %ld", tagView.class, (long)index];
}

#pragma mark - TTGTagCollectionViewDataSource

- (NSInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView {
    return self.tagViews.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSInteger)index {
    return self.tagViews[index];
}

#pragma mark - View factories

- (UILabel *)labelWithText:(NSString *)text
                  fontSize:(CGFloat)fontSize
                 textColor:(UIColor *)textColor
                background:(UIColor *)bg {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = textColor;
    label.backgroundColor = bg;
    [label sizeToFit];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 12;
    [self padView:label width:12 height:8];
    return label;
}

- (UIButton *)buttonWithTitle:(NSString *)title fontSize:(CGFloat)fontSize background:(UIColor *)bg {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = bg;
    [button sizeToFit];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 12;
    [self padView:button width:12 height:8];
    [button addTarget:self action:@selector(tagButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIImageView *)imageNamed:(NSString *)name {
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    [iv sizeToFit];
    return iv;
}

- (void)padView:(UIView *)view width:(CGFloat)w height:(CGFloat)h {
    CGRect f = view.frame;
    f.size.width += w;
    f.size.height += h;
    view.frame = f;
}

- (void)tagButtonTapped:(UIButton *)sender {
    self.logLabel.text = @"Tap tag button !";
}

@end
