//
//  TTGDemoTagAttachmentViewController.m
//

#import "TTGDemoTagAttachmentViewController.h"
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
    [self setupViews];
    [self setupConstraints];
    [self loadAttachmentDemonstrationTags];
    self.tagView.delegate = self;
}

#pragma mark - UI

- (void)setupViews {
    self.tagView = [TTGTextTagCollectionView new];
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.layer.borderColor = UIColor.grayColor.CGColor;
    self.tagView.layer.borderWidth = 1;
    self.tagView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tagView];

    self.logTextView = [UITextView new];
    self.logTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.logTextView.layer.borderWidth = 1;
    self.logTextView.textColor = UIColor.grayColor;
    self.logTextView.font = [UIFont systemFontOfSize:12];
    self.logTextView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logTextView.contentInset = UIEdgeInsetsZero;
    self.logTextView.textContainerInset = UIEdgeInsetsZero;
    self.logTextView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:self.logTextView];
}

- (void)setupConstraints {
    NSDictionary *views = @{ @"tv": self.tagView, @"log": self.logTextView };

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[tv]-20-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[log]-20-|"
                                                                      options:0 metrics:nil views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tagView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view.safeAreaLayoutGuide
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logTextView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.tagView
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.logTextView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1 constant:-20]];
}

#pragma mark - Tags

- (TTGTextTagStyle *)sharedBlueTagChrome {
    TTGTextTagStyle *s = [TTGTextTagStyle new];
    s.backgroundColor = [UIColor colorWithRed:0.24 green:0.72 blue:0.94 alpha:1];
    s.borderColor = UIColor.whiteColor;
    s.borderWidth = 1;
    s.cornerRadius = 4;
    s.extraSpace = CGSizeMake(8, 8);
    s.shadowColor = UIColor.blackColor;
    s.shadowOpacity = 0.3;
    s.shadowRadius = 2;
    s.shadowOffset = CGSizeMake(1, 1);
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
