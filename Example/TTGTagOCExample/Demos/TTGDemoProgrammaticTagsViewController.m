//
//  TTGDemoProgrammaticTagsViewController.m
//

#import "TTGDemoProgrammaticTagsViewController.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

@interface TTGDemoProgrammaticTagsViewController ()
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@end

@implementation TTGDemoProgrammaticTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTagCollectionViewHierarchy];
    [self applyLayoutConstraints];
    [self populateTagsFromSampleWords];
}

#pragma mark - View hierarchy

- (void)setupTagCollectionViewHierarchy {
    self.tagView = [TTGTextTagCollectionView new];
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.layer.borderColor = UIColor.grayColor.CGColor;
    self.tagView.layer.borderWidth = 1;
    self.tagView.translatesAutoresizingMaskIntoConstraints = NO;

    self.tagView.onTapAllArea = ^(CGPoint location) {
        NSLog(@"onTapAllArea: %@", NSStringFromCGPoint(location));
    };
    self.tagView.onTapBlankArea = ^(CGPoint location) {
        NSLog(@"onTapBlankArea: %@", NSStringFromCGPoint(location));
    };

    [self.view addSubview:self.tagView];
}

#pragma mark - Layout

- (void)applyLayoutConstraints {
    NSDictionary *views = @{ @"tagView": self.tagView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[tagView]-20-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tagView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1 constant:180]];
}

#pragma mark - Data

- (void)populateTagsFromSampleWords {
    NSArray<NSString *> *words = [TTGTagSampleData shortSampleWords];
    NSMutableArray<TTGTextTag *> *tags = [NSMutableArray array];
    for (NSString *word in words) {
        TTGTextTag *t = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:word]
                                             style:[TTGTextTagStyle new]];
        t.selectedStyle.backgroundColor = [UIColor greenColor];
        [tags addObject:t];
    }
    [self.tagView addTags:tags];

    for (NSInteger i = 0; i < 5; i++) {
        [self.tagView updateTagAtIndex:arc4random_uniform((uint32_t)words.count) selected:YES];
    }
    [self.tagView reload];
}

@end
