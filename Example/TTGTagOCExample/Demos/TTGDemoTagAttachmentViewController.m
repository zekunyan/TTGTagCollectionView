//
//  TTGDemoTagAttachmentViewController.m
//

#import "TTGDemoTagAttachmentViewController.h"
#import "TTGDemoUI.h"
#import <TTGTags/TTGTags-Swift.h>

#pragma mark - Sample model

@interface TTGDemoCustomPayload : NSObject
@property (nonatomic, copy) NSString *info;
@end

@implementation TTGDemoCustomPayload
- (NSString *)description {
    return [NSString stringWithFormat:@"TTGDemoCustomPayload{%@}", self.info];
}
@end

#pragma mark - Screen

@interface TTGDemoTagAttachmentViewController () <TTGTextTagCollectionViewDelegate>
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@property (nonatomic, strong) UITextView *logTextView;
@end

@implementation TTGDemoTagAttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [TTGDemoUI applyScreenBackground:self.view];
    [self setupViews];
    [self setupConstraints];
    [self loadAttachmentDemonstrationTags];
    self.tagView.delegate = self;
}

#pragma mark - UI

- (void)setupViews {
    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Bind data to tag"];
    titleLabel.tag = 1001;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titleLabel];

    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Stores custom NSObject, NSDictionary, and NSString values in TTGTextTag. Tap a tag to read the attachment from the delegate callback."];
    descriptionLabel.tag = 1002;
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:descriptionLabel];

    self.tagView = [TTGTextTagCollectionView new];
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.horizontalSpacing = 8;
    self.tagView.verticalSpacing = 8;
    self.tagView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [TTGDemoUI styleTagSurface:self.tagView];
    self.tagView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tagView];

    self.logTextView = [UITextView new];
    [TTGDemoUI styleLogTextView:self.logTextView];
    self.logTextView.text = @"Tap a tag to print its bound attachment here.";
    self.logTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logTextView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:self.logTextView];
}

- (void)setupConstraints {
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:1001];
    UILabel *descriptionLabel = (UILabel *)[self.view viewWithTag:1002];
    NSDictionary *views = @{ @"title": titleLabel, @"desc": descriptionLabel, @"tv": self.tagView, @"log": self.logTextView };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[title]-16-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[desc]-16-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[tv]-16-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[log]-16-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view.safeAreaLayoutGuide
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1 constant:16]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:titleLabel
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1 constant:8]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tagView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:descriptionLabel
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1 constant:18]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logTextView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.tagView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1 constant:16]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logTextView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1 constant:-16]];
}

#pragma mark - Tags

- (TTGTextTagStyle *)sharedBlueTagChrome {
    TTGTextTagStyle *s = [TTGTextTagStyle new];
    s.backgroundColor = UIColor.systemBlueColor;
    s.borderWidth = 0;
    s.cornerRadius = 14;
    s.extraSpace = CGSizeMake(12, 6);
    s.shadowOpacity = 0;
    return s;
}

- (void)loadAttachmentDemonstrationTags {
    TTGDemoCustomPayload *payload = [TTGDemoCustomPayload new];
    payload.info = @"Custom NSObject payload";

    NSArray<NSDictionary *> *items = @[
        @{ @"title": @"Bind NSObject", @"attach": payload },
        @{ @"title": @"Bind NSDictionary", @"attach": @{ @"info": @"NSDictionary payload" } },
        @{ @"title": @"Bind NSString A", @"attach": @"String A" },
        @{ @"title": @"Bind NSString B", @"attach": @"String B" },
    ];

    for (NSDictionary *item in items) {
        TTGTextTagStringContent *content = [TTGTextTagStringContent new];
        content.text = item[@"title"];
        TTGTextTag *tag = [TTGTextTag new];
        tag.attachment = item[@"attach"];
        tag.style = [self sharedBlueTagChrome];
        tag.content = content;
        [self.tagView addTag:tag];
    }

    [self.tagView reload];
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSInteger)index {
    self.logTextView.text =
        [NSString stringWithFormat:@"%@\nTapped attachment:\n%@\n\n", self.logTextView.text ?: @"", tag.attachment];
}

@end
