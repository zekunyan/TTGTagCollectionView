//
//  TTGDemoTagsTableViewCell.m
//

#import "TTGDemoTagsTableViewCell.h"
#import "TTGDemoUI.h"
#import <TTGTags/TTGTags-Swift.h>

@implementation TTGDemoTagsTableViewCell

static const CGFloat kTagViewHorizontalMargin = 16;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.systemBackgroundColor;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureTagView];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat availableWidth = CGRectGetWidth(self.contentView.bounds) - kTagViewHorizontalMargin * 2;
    if (availableWidth > 0 && fabs(self.tagView.preferredMaxLayoutWidth - availableWidth) > 0.5) {
        self.tagView.preferredMaxLayoutWidth = availableWidth;
        [self.tagView reload];
    }
}

- (void)setupViews {
    self.label = [UILabel new];
    self.label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    self.label.textColor = UIColor.secondaryLabelColor;
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.label];

    self.tagView = [TTGTextTagCollectionView new];
    [TTGDemoUI styleTagSurface:self.tagView];
    self.tagView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.tagView];

    [NSLayoutConstraint activateConstraints:@[
        [self.label.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12],
        [self.label.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kTagViewHorizontalMargin],
        [self.label.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kTagViewHorizontalMargin],

        [self.tagView.topAnchor constraintEqualToAnchor:self.label.bottomAnchor constant:8],
        [self.tagView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:kTagViewHorizontalMargin],
        [self.tagView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-kTagViewHorizontalMargin],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.tagView.bottomAnchor constant:12],
    ]];

    [self configureTagView];
}

- (void)configureTagView {
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.manualCalculateHeight = YES;
    self.tagView.horizontalSpacing = 6;
    self.tagView.verticalSpacing = 6;
    self.tagView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8);
    self.tagView.showsHorizontalScrollIndicator = NO;
    self.tagView.scrollView.alwaysBounceHorizontal = NO;
    self.tagView.scrollView.directionalLockEnabled = YES;
}

- (void)configureWithTags:(NSArray<TTGTextTag *> *)tags availableWidth:(CGFloat)availableWidth {
    CGFloat tagWidth = MAX(0, availableWidth);
    if (tagWidth > 0) {
        self.tagView.preferredMaxLayoutWidth = tagWidth;
    }

    [self.tagView removeAllTags];
    [self.tagView addTags:tags];

    CGFloat contentAvailableWidth = CGRectGetWidth(self.contentView.bounds) - kTagViewHorizontalMargin * 2;
    if (contentAvailableWidth > 0) {
        self.tagView.preferredMaxLayoutWidth = contentAvailableWidth;
    }

    [self.tagView reload];
}

@end
