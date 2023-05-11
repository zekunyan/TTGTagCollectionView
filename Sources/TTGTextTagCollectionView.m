//
//  TTGTextTagCollectionView.m
//  Pods
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

#import "TTGTextTagCollectionView.h"

#pragma mark - TTGTextTagGradientLabel

@interface TTGTextTagGradientLabel : UILabel
@end

@implementation TTGTextTagGradientLabel
+ (Class)layerClass {
    return [CAGradientLayer class];
}
@end

#pragma mark - TTGTextTagLabel

@interface TTGTextTagComponentView : UIView
@property (nonatomic, strong) TTGTextTag *config;
@property (nonatomic, strong) TTGTextTagGradientLabel *label;
@property (nonatomic, strong) CAShapeLayer *borderLayer;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToComponentView:(TTGTextTagComponentView *)label;

- (NSUInteger)hash;
@end

@implementation TTGTextTagComponentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _label = [[TTGTextTagGradientLabel alloc] initWithFrame:self.bounds];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.userInteractionEnabled = YES;
    _label.isAccessibilityElement = NO;
    [self addSubview:_label];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];

    // Update frame
    _label.frame = self.bounds;

    // Get new path
    UIBezierPath *path = [self getNewPath];
    // Mask
    [self updateMaskWithPath:path];
    // Border
    [self updateBorderWithPath:path];
    // Shadow
    [self updateShadowWithPath:path];
}

#pragma mark - intrinsicContentSize

- (CGSize)intrinsicContentSize {
    return _label.intrinsicContentSize;
}

#pragma mark - Apply config

- (void)updateContent {
    // Content
    _label.attributedText = _config.getRightfulContent.getContentAttributedString;
}

- (void)updateContentStyle {
    // Normal background
    _label.backgroundColor = _config.getRightfulStyle.backgroundColor ?: UIColor.clearColor;
    
    // Text alignment
    _label.textAlignment = _config.getRightfulStyle.textAlignment;

    // Gradient background
    if (_config.getRightfulStyle.enableGradientBackground) {
        _label.backgroundColor = [UIColor clearColor];
        ((CAGradientLayer *)_label.layer).backgroundColor = UIColor.clearColor.CGColor;
        ((CAGradientLayer *)_label.layer).colors = @[(id)_config.getRightfulStyle.gradientBackgroundStartColor.CGColor,
                                                     (id)_config.getRightfulStyle.gradientBackgroundEndColor.CGColor];
        ((CAGradientLayer *)_label.layer).startPoint = _config.getRightfulStyle.gradientBackgroundStartPoint;
        ((CAGradientLayer *)_label.layer).endPoint = _config.getRightfulStyle.gradientBackgroundEndPoint;
    }
}

- (void)updateFrameWithMaxSize:(CGSize)maxSize {
    [_label sizeToFit];

    CGSize finalSize = _label.frame.size;

    finalSize.width += _config.getRightfulStyle.extraSpace.width;
    finalSize.height += _config.getRightfulStyle.extraSpace.height;

    if (_config.getRightfulStyle.maxWidth > 0 && finalSize.width > _config.getRightfulStyle.maxWidth) {
        finalSize.width = _config.getRightfulStyle.maxWidth;
    }
    if (_config.getRightfulStyle.minWidth > 0 && finalSize.width < _config.getRightfulStyle.minWidth) {
        finalSize.width = _config.getRightfulStyle.minWidth;
    }
    if (_config.getRightfulStyle.exactWidth > 0) {
        finalSize.width = _config.getRightfulStyle.exactWidth;
    }
    if (_config.getRightfulStyle.exactHeight > 0) {
        finalSize.height = _config.getRightfulStyle.exactHeight;
    }

    if (maxSize.width > 0) {
        finalSize.width = MIN(maxSize.width, finalSize.width);
    }
    if (maxSize.height > 0) {
        finalSize.height = MIN(maxSize.height, finalSize.height);
    }

    CGRect frame = self.frame;
    frame.size = finalSize;
    self.frame = frame;
    _label.frame = self.bounds;
}

- (void)updateShadowWithPath:(UIBezierPath *)path {
    self.layer.shadowColor = _config.getRightfulStyle.shadowColor.CGColor;
    self.layer.shadowOffset = _config.getRightfulStyle.shadowOffset;
    self.layer.shadowRadius = _config.getRightfulStyle.shadowRadius;
    self.layer.shadowOpacity = (float)_config.getRightfulStyle.shadowOpacity;
    self.layer.shadowPath = path.CGPath;
    self.layer.shouldRasterize = YES;
    [self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
}

- (void)updateMaskWithPath:(UIBezierPath *)path {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    _label.layer.mask = maskLayer;
}

- (void)updateBorderWithPath:(UIBezierPath *)path {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer new];
    }
    [_borderLayer removeFromSuperlayer];
    _borderLayer.frame = self.bounds;
    _borderLayer.path = path.CGPath;
    _borderLayer.fillColor = UIColor.clearColor.CGColor;
    _borderLayer.opacity = 1;
    _borderLayer.lineWidth = _config.getRightfulStyle.borderWidth;
    _borderLayer.strokeColor = _config.getRightfulStyle.borderColor.CGColor;
    _borderLayer.lineCap = kCALineCapRound;
    _borderLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:_borderLayer];
}

- (void)updateAccessibility {
    self.isAccessibilityElement = _config.isAccessibilityElement;
    self.accessibilityIdentifier = _config.accessibilityIdentifier;
    self.accessibilityLabel = _config.accessibilityLabel;
    self.accessibilityHint = _config.accessibilityHint;
    self.accessibilityValue = _config.accessibilityValue;
    self.accessibilityTraits = _config.accessibilityTraits;
}

- (UIBezierPath *)getNewPath {
    // Round corner
    UIRectCorner corners = (UIRectCorner)-1;
    if (_config.getRightfulStyle.cornerTopLeft) {
        corners = UIRectCornerTopLeft;
    }
    if (_config.getRightfulStyle.cornerTopRight) {
        if (corners == -1) {
            corners = UIRectCornerTopRight;
        } else {
            corners = corners | UIRectCornerTopRight;
        }
    }
    if (_config.getRightfulStyle.cornerBottomLeft) {
        if (corners == -1) {
            corners = UIRectCornerBottomLeft;
        } else {
            corners = corners | UIRectCornerBottomLeft;
        }
    }
    if (_config.getRightfulStyle.cornerBottomRight) {
        if (corners == -1) {
            corners = UIRectCornerBottomRight;
        } else {
            corners = corners | UIRectCornerBottomRight;
        }
    }

    // Corner radius
    CGFloat currentCornerRadius = _config.getRightfulStyle.cornerRadius;

    // Path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:corners
                                                     cornerRadii:CGSizeMake(currentCornerRadius, currentCornerRadius)];
    return path;
}

#pragma mark - Base

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;
    return [self isEqualToComponentView:other];
}

- (BOOL)isEqualToComponentView:(TTGTextTagComponentView *)label {
    if (self == label)
        return YES;
    if (label == nil)
        return NO;
    if (self.config != label.config && ![self.config isEqualToTag:label.config])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return [self.config hash];
}

@end

#pragma mark - TTGTextTagCollectionView

@interface TTGTextTagCollectionView () <TTGTagCollectionViewDataSource, TTGTagCollectionViewDelegate>
@property (strong, atomic) NSMutableArray <TTGTextTagComponentView *> *tagLabels;
@property (strong, nonatomic) TTGTagCollectionView *tagCollectionView;
@end

@implementation TTGTextTagCollectionView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    if (_tagCollectionView) {
        return;
    }

    _enableTagSelection = YES;
    _tagLabels = [NSMutableArray new];

    _tagCollectionView = [[TTGTagCollectionView alloc] initWithFrame:self.bounds];
    _tagCollectionView.delegate = self;
    _tagCollectionView.dataSource = self;
    _tagCollectionView.horizontalSpacing = 8;
    _tagCollectionView.verticalSpacing = 8;
    [self addSubview:_tagCollectionView];
}

#pragma mark - Override

- (CGSize)intrinsicContentSize {
    return [_tagCollectionView intrinsicContentSize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(_tagCollectionView.frame, self.bounds)) {
        [self updateAllLabelStyleAndFrame];
        _tagCollectionView.frame = self.bounds;
        [_tagCollectionView setNeedsLayout];
        [_tagCollectionView layoutIfNeeded];
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.contentSize;
}

#pragma mark - Public methods

- (void)reload {
    [self updateAllLabelStyleAndFrame];
    [_tagCollectionView reload];
    [self invalidateIntrinsicContentSize];
}

- (void)addTag:(TTGTextTag *)tag {
    [self insertTag:tag atIndex:_tagLabels.count];
}

- (void)addTags:(NSArray <TTGTextTag *> *)tags {
    [self insertTags:tags atIndex:_tagLabels.count];
}

- (void)insertTag:(TTGTextTag *)tag atIndex:(NSUInteger)index {
    if ([tag isKindOfClass:[TTGTextTag class]]) {
        [self insertTags:@[tag] atIndex:index];
    }
}

- (void)insertTags:(NSArray<TTGTextTag *> *)tags atIndex:(NSUInteger)index {
    if (![tags isKindOfClass:[NSArray class]] || index > _tagLabels.count || tags.count == 0) {
        return;
    }

    NSMutableArray *newTagLabels = [NSMutableArray new];
    for (TTGTextTag *tag in tags) {
        if ([tag isKindOfClass:[TTGTextTag class]]) {
            TTGTextTagComponentView *label = [self newLabelWithConfig:tag];
            [newTagLabels addObject:label];
        }
    }
    [_tagLabels insertObjects:newTagLabels atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, newTagLabels.count)]];
}

- (void)removeTag:(TTGTextTag *)tag {
    if ([tag isKindOfClass:[TTGTextTag class]]) {
        [self removeTagById:tag.tagId];
    }
}

- (void)removeTagById:(NSUInteger)tagId {
    TTGTextTagComponentView *labelToRemove = nil;
    for (TTGTextTagComponentView *label in _tagLabels) {
        if (label.config.tagId == tagId) {
            labelToRemove = label;
        }
    }
    if (labelToRemove) {
        [_tagLabels removeObject:labelToRemove];
    }
}

- (void)removeTagAtIndex:(NSUInteger)index {
    if (index >= _tagLabels.count) {
        return;
    }
    [_tagLabels removeObjectAtIndex:index];
}

- (void)removeAllTags {
    [_tagLabels removeAllObjects];
}

- (void)updateTagAtIndex:(NSUInteger)index selected:(BOOL)selected {
    TTGTextTag *tag = [self getTagAtIndex:index];
    tag.selected = selected;
}

- (void)updateTagAtIndex:(NSUInteger)index withNewTag:(TTGTextTag *)tag {
    if (index < _tagLabels.count && [tag isKindOfClass:[TTGTextTag class]]) {
        TTGTextTagComponentView *label = _tagLabels[index];
        label.config = tag;
        [label updateContent];
    }
}

- (TTGTextTag *)getTagAtIndex:(NSUInteger)index {
    if (index < _tagLabels.count) {
        return _tagLabels[index].config;
    } else {
        return nil;
    }
}

- (NSArray<TTGTextTag *> *)getTagsInRange:(NSRange)range {
    if (NSMaxRange(range) <= _tagLabels.count) {
        NSMutableArray *tags = [NSMutableArray new];
        for (TTGTextTagComponentView *label in [_tagLabels subarrayWithRange:range]) {
            if (label.config) {
                [tags addObject:label.config];
            }
        }
        return [tags copy];
    } else {
        return nil;
    }
}

- (NSArray <TTGTextTag *> *)allTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagComponentView *label in _tagLabels) {
        if (label.config) {
            [allTags addObject:label.config];
        }
    }

    return [allTags copy];
}

- (NSArray <TTGTextTag *> *)allSelectedTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagComponentView *label in _tagLabels) {
        if (label.config.selected) {
            [allTags addObject:label.config];
        }
    }

    return [allTags copy];
}

- (NSArray <TTGTextTag *> *)allNotSelectedTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagComponentView *label in _tagLabels) {
        if (label.config && !label.config.selected) {
            [allTags addObject:label.config];
        }
    }

    return [allTags copy];
}

- (NSInteger)indexOfTagAtPoint:(CGPoint)point {
    CGPoint convertedPoint = [self convertPoint:point toView:_tagCollectionView];
    return [_tagCollectionView indexOfTagAt:convertedPoint];
}

#pragma mark - TTGTagCollectionViewDataSource

- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView {
    return _tagLabels.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index {
    return _tagLabels[index];
}

#pragma mark - TTGTagCollectionViewDelegate

- (BOOL)tagCollectionView:(TTGTagCollectionView *)tagCollectionView shouldSelectTag:(UIView *)tagView atIndex:(NSUInteger)index {
    if (_enableTagSelection) {
        TTGTextTagComponentView *label = _tagLabels[index];

        if ([self.delegate respondsToSelector:@selector(textTagCollectionView:canTapTag:atIndex:)]) {
            return [self.delegate textTagCollectionView:self canTapTag:label.config atIndex:index];
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index {
    if (_enableTagSelection) {
        TTGTextTagComponentView *label = _tagLabels[index];

        if (!label.config.selected && _selectionLimit > 0 && [self allSelectedTags].count + 1 > _selectionLimit) {
            return;
        }

        label.config.selected = !label.config.selected;

        if (self.alignment == TTGTagCollectionAlignmentFillByExpandingWidth ||
            self.alignment == TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine) {
            [self reload];
        } else {
            [self updateStyleAndFrameForLabel:label];
        }
        
        if ([_delegate respondsToSelector:@selector(textTagCollectionView:didTapTag:atIndex:)]) {
            [_delegate textTagCollectionView:self didTapTag:label.config atIndex:index];
        }
    }
}

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index {
    return _tagLabels[index].frame.size;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView updateContentSize:(CGSize)contentSize {
    if ([_delegate respondsToSelector:@selector(textTagCollectionView:updateContentSize:)]) {
        [_delegate textTagCollectionView:self updateContentSize:contentSize];
    }
}

#pragma mark - Setter and Getter

- (UIScrollView *)scrollView {
    return _tagCollectionView.scrollView;
}

- (CGFloat)horizontalSpacing {
    return _tagCollectionView.horizontalSpacing;
}

- (void)setHorizontalSpacing:(CGFloat)horizontalSpacing {
    _tagCollectionView.horizontalSpacing = horizontalSpacing;
}

- (CGFloat)verticalSpacing {
    return _tagCollectionView.verticalSpacing;
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing {
    _tagCollectionView.verticalSpacing = verticalSpacing;
}

- (CGSize)contentSize {
    return _tagCollectionView.contentSize;
}

- (TTGTagCollectionScrollDirection)scrollDirection {
    return _tagCollectionView.scrollDirection;
}

- (void)setScrollDirection:(TTGTagCollectionScrollDirection)scrollDirection {
    _tagCollectionView.scrollDirection = scrollDirection;
}

- (TTGTagCollectionAlignment)alignment {
    return _tagCollectionView.alignment;
}

- (void)setAlignment:(TTGTagCollectionAlignment)alignment {
    _tagCollectionView.alignment = alignment;
}

- (NSUInteger)numberOfLines {
    return _tagCollectionView.numberOfLines;
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    _tagCollectionView.numberOfLines = numberOfLines;
}

- (NSUInteger)actualNumberOfLines {
    return _tagCollectionView.actualNumberOfLines;
}

- (UIEdgeInsets)contentInset {
    return _tagCollectionView.contentInset;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _tagCollectionView.contentInset = contentInset;
}

- (BOOL)manualCalculateHeight {
    return _tagCollectionView.manualCalculateHeight;
}

- (void)setManualCalculateHeight:(BOOL)manualCalculateHeight {
    _tagCollectionView.manualCalculateHeight = manualCalculateHeight;
}

- (CGFloat)preferredMaxLayoutWidth {
    return _tagCollectionView.preferredMaxLayoutWidth;
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    _tagCollectionView.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator {
    _tagCollectionView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (BOOL)showsHorizontalScrollIndicator {
    return _tagCollectionView.showsHorizontalScrollIndicator;
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator {
    _tagCollectionView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

- (BOOL)showsVerticalScrollIndicator {
    return _tagCollectionView.showsVerticalScrollIndicator;
}

- (void)setOnTapBlankArea:(void (^)(CGPoint location))onTapBlankArea {
    _tagCollectionView.onTapBlankArea = onTapBlankArea;
}

- (void (^)(CGPoint location))onTapBlankArea {
    return _tagCollectionView.onTapBlankArea;
}

- (void)setOnTapAllArea:(void (^)(CGPoint location))onTapAllArea {
    _tagCollectionView.onTapAllArea = onTapAllArea;
}

- (void (^)(CGPoint location))onTapAllArea {
    return _tagCollectionView.onTapAllArea;
}

#pragma mark - Private methods

- (void)updateAllLabelStyleAndFrame {
    for (TTGTextTagComponentView *label in _tagLabels) {
        [self updateStyleAndFrameForLabel:label];
    }
}

- (void)updateStyleAndFrameForLabel:(TTGTextTagComponentView *)label {
    // Update content
    [label updateContent];
    // Update content style
    [label updateContentStyle];
    // Update accessibility
    [label updateAccessibility];
    // Width limit for vertical scroll direction
    CGSize maxSize = CGSizeZero;
    if (self.scrollDirection == TTGTagCollectionScrollDirectionVertical &&
            CGRectGetWidth(self.bounds) > 0) {
        maxSize.width = (CGRectGetWidth(self.bounds) - self.contentInset.left - self.contentInset.right);
    }
    // Update frame
    [label updateFrameWithMaxSize:maxSize];
}

- (TTGTextTagComponentView *)newLabelWithConfig:(TTGTextTag *)config {
    TTGTextTagComponentView *label = [TTGTextTagComponentView new];
    label.config = config;
    return label;
}

@end
