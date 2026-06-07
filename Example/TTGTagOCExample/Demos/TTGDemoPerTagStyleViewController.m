//
//  TTGDemoPerTagStyleViewController.m
//

#import "TTGDemoPerTagStyleViewController.h"
#import "TTGDemoUI.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

#pragma mark - Batch builder (decoupled from view controller)

@interface TTGDemoPerTagStyleBatchBuilder : NSObject
+ (void)addBatchWithWords:(NSArray<NSString *> *)words
                    range:(NSRange)range
                tagView:(TTGTextTagCollectionView *)tagView
          backgroundColor:(UIColor *)backgroundColor
               attachment:(id _Nullable)attachment;
+ (UIColor *)complementApproximate:(UIColor *)color;
@end

@implementation TTGDemoPerTagStyleBatchBuilder

+ (void)addBatchWithWords:(NSArray<NSString *> *)words
                    range:(NSRange)range
                  tagView:(TTGTextTagCollectionView *)tagView
          backgroundColor:(UIColor *)backgroundColor
               attachment:(id)attachment {
    static TTGTextTagStyle *baseStyleTemplate = nil;
    static TTGTextTagStringContent *baseContentTemplate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseStyleTemplate = [TTGTextTagStyle new];
        baseStyleTemplate.backgroundColor = UIColor.systemBlueColor;
        baseStyleTemplate.borderWidth = 0;
        baseStyleTemplate.cornerRadius = 14;
        baseStyleTemplate.extraSpace = CGSizeMake(12, 6);
        baseStyleTemplate.shadowOpacity = 0;

        baseContentTemplate = [TTGTextTagStringContent new];
        baseContentTemplate.textFont = [UIFont systemFontOfSize:20];
        baseContentTemplate.textColor = UIColor.whiteColor;
    });

    NSArray<NSString *> *slice = [words subarrayWithRange:range];
    for (NSString *text in slice) {
        TTGTextTag *tag = [TTGTextTag new];

        tag.isAccessibilityElement = YES;
        tag.accessibilityLabel = text;
        tag.accessibilityIdentifier = [NSString stringWithFormat:@"identifier: %@", text];
        tag.accessibilityHint = [NSString stringWithFormat:@"hint: %@", text];
        tag.accessibilityValue = [NSString stringWithFormat:@"value: %@", text];

        TTGTextTagStyle *style = [baseStyleTemplate copy];
        style.backgroundColor = backgroundColor;

        TTGTextTagStyle *selectedStyle = [style copy];
        selectedStyle.backgroundColor = UIColor.systemIndigoColor;
        selectedStyle.borderWidth = 0;
        selectedStyle.cornerRadius = 14;
        selectedStyle.shadowOpacity = 0;

        TTGTextTagStringContent *content = [baseContentTemplate copy];
        content.text = text;

        tag.style = style;
        tag.selectedStyle = selectedStyle;
        tag.content = content;
        tag.attachment = attachment;
        [tagView addTag:tag];
    }

    [tagView updateTagAtIndex:range.location + arc4random_uniform((uint32_t)range.length) selected:YES];
}

+ (UIColor *)complementApproximate:(UIColor *)color {
    CGFloat r = 0, g = 0, b = 0;
    [color getRed:&r green:&g blue:&b alpha:NULL];
    return [UIColor colorWithRed:1 - r green:1 - g blue:1 - b alpha:1];
}

@end

#pragma mark - Screen

@interface TTGDemoPerTagStyleViewController () <TTGTextTagCollectionViewDelegate>
@property (strong, nonatomic) TTGTextTagCollectionView *tagView;
@end

@implementation TTGDemoPerTagStyleViewController

- (void)loadView {
    UIView *view = [UIView new];
    [TTGDemoUI applyScreenBackground:view];

    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Each tag can be different"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Builds batches with different colors, selected styles, accessibility values, and attachments. Tap a tag and inspect the console output."];
    self.tagView = [TTGTextTagCollectionView new];
    [TTGDemoUI styleTagSurface:self.tagView];
    self.tagView.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:titleLabel];
    [view addSubview:descriptionLabel];
    [view addSubview:self.tagView];

    UILayoutGuide *safeArea = view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:16],
        [titleLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [titleLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],

        [descriptionLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        [descriptionLabel.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [descriptionLabel.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],

        [self.tagView.topAnchor constraintEqualToAnchor:descriptionLabel.bottomAnchor constant:18],
        [self.tagView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:16],
        [self.tagView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-16],
        [safeArea.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.tagView.bottomAnchor constant:16],
    ]];

    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.delegate = self;
    self.tagView.horizontalSpacing = 8;
    self.tagView.verticalSpacing = 8;
    self.tagView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);

    NSArray<NSString *> *pool = [TTGTagSampleData shortWordsRepeated:3];
    NSUInteger batchSize = 8;
    NSArray<UIColor *> *palette = @[
        UIColor.systemBlueColor,
        UIColor.systemTealColor,
        UIColor.systemGreenColor,
        UIColor.systemOrangeColor,
        UIColor.systemPurpleColor,
        UIColor.systemPinkColor,
        UIColor.systemIndigoColor,
        UIColor.systemGrayColor,
    ];

    for (NSUInteger i = 0; i < palette.count; i++) {
        NSUInteger loc = i * batchSize;
        if (loc + batchSize > pool.count) break;
        [TTGDemoPerTagStyleBatchBuilder addBatchWithWords:pool
                                                    range:NSMakeRange(loc, batchSize)
                                                  tagView:self.tagView
                                          backgroundColor:palette[i]
                                               attachment:@{ @"group": @(i + 1) }];
    }

    [self.tagView reload];
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSInteger)index {
    NSLog(@"Did tap: %@, attachment: %@", tag.content, tag.attachment);
}

@end
