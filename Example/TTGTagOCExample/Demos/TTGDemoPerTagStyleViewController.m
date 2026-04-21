//
//  TTGDemoPerTagStyleViewController.m
//

#import "TTGDemoPerTagStyleViewController.h"
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
        baseStyleTemplate.backgroundColor = UIColor.whiteColor;
        baseStyleTemplate.borderColor = UIColor.whiteColor;
        baseStyleTemplate.borderWidth = 1;
        baseStyleTemplate.cornerRadius = 4;
        baseStyleTemplate.extraSpace = CGSizeMake(8, 8);
        baseStyleTemplate.shadowColor = UIColor.blackColor;
        baseStyleTemplate.shadowOpacity = 0.3;
        baseStyleTemplate.shadowRadius = 2;
        baseStyleTemplate.shadowOffset = CGSizeMake(1, 1);

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
        selectedStyle.backgroundColor = [self complementApproximate:style.backgroundColor];
        selectedStyle.borderColor = UIColor.blackColor;
        selectedStyle.cornerRadius = 8;
        selectedStyle.shadowColor = UIColor.greenColor;

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
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
@end

@implementation TTGDemoPerTagStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.delegate = self;

    NSArray<NSString *> *pool = [TTGTagSampleData shortWordsRepeated:3];
    NSUInteger batchSize = 8;
    NSArray<UIColor *> *palette = @[
        [UIColor colorWithRed:0.24 green:0.72 blue:0.94 alpha:1],
        [UIColor colorWithRed:0.30 green:0.72 blue:0.53 alpha:1],
        [UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1],
        [UIColor colorWithRed:0.73 green:0.91 blue:0.41 alpha:1],
        [UIColor colorWithRed:0.35 green:0.35 blue:0.36 alpha:1],
        [UIColor colorWithRed:1.00 green:0.41 blue:0.42 alpha:1],
        [UIColor colorWithRed:0.50 green:0.86 blue:0.90 alpha:1],
        [UIColor colorWithRed:0.33 green:0.23 blue:0.34 alpha:1],
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
