//
// Created by zorro on 15/12/28.
//

#import "TTGTextTagCollectionView.h"

#pragma mark - -----TTGTextTagConfig-----

@implementation TTGTextTagConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _tagTextFont = [UIFont systemFontOfSize:16.0f];
        
        _tagTextColor = [UIColor whiteColor];
        _tagSelectedTextColor = [UIColor whiteColor];
        
        _tagBackgroundColor = [UIColor colorWithRed:0.30 green:0.72 blue:0.53 alpha:1.00];
        _tagSelectedBackgroundColor = [UIColor colorWithRed:0.22 green:0.29 blue:0.36 alpha:1.00];
        
        _tagCornerRadius = 4.0f;
        _tagSelectedCornerRadius = 4.0f;
        
        _tagBorderWidth = 1.0f;
        _tagSelectedBorderWidth = 1.0f;
        
        _tagBorderColor = [UIColor whiteColor];
        _tagSelectedBorderColor = [UIColor whiteColor];
        
        _tagShadowColor = [UIColor blackColor];
        _tagShadowOffset = CGSizeMake(2, 2);
        _tagShadowRadius = 2;
        _tagShadowOpacity = 0.3f;
        
        _tagExtraSpace = CGSizeMake(14, 14);
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    TTGTextTagConfig *newConfig = [TTGTextTagConfig new];
    newConfig.tagTextFont = [_tagTextFont copyWithZone:zone];
    
    newConfig.tagTextColor = [_tagTextColor copyWithZone:zone];
    newConfig.tagSelectedTextColor = [_tagSelectedTextColor copyWithZone:zone];
    
    newConfig.tagBackgroundColor = [_tagBackgroundColor copyWithZone:zone];
    newConfig.tagSelectedBackgroundColor = [_tagSelectedBackgroundColor copyWithZone:zone];
    
    newConfig.tagCornerRadius = _tagCornerRadius;
    newConfig.tagSelectedCornerRadius = _tagSelectedCornerRadius;
    
    newConfig.tagBorderWidth = _tagBorderWidth;
    newConfig.tagSelectedBorderWidth = _tagSelectedBorderWidth;
    
    newConfig.tagBorderColor = [_tagBorderColor copyWithZone:zone];
    newConfig.tagSelectedBorderColor = [_tagSelectedBorderColor copyWithZone:zone];
    
    newConfig.tagShadowColor = [_tagShadowColor copyWithZone:zone];
    newConfig.tagShadowOffset = _tagShadowOffset;
    newConfig.tagShadowRadius = _tagShadowRadius;
    newConfig.tagShadowOpacity = _tagShadowOpacity;
    
    newConfig.tagExtraSpace = _tagExtraSpace;
    
    return newConfig;
}

@end

#pragma mark - -----TTGTextTagLabel-----

// UILabel wrapper for round corner and shadow at the same time.
@interface TTGTextTagLabel : UIView
@property (nonatomic, strong) TTGTextTagConfig *config;
@property (nonatomic, strong) UILabel *label;
@property (assign, nonatomic) BOOL selected;
@end

@implementation TTGTextTagLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = self.bounds;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_label.bounds
                                                       cornerRadius:_label.layer.cornerRadius].CGPath;
}

- (void)sizeToFit {
    [_label sizeToFit];
    CGRect frame = self.frame;
    frame.size = _label.frame.size;
    self.frame = frame;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [_label sizeThatFits:size];
}

- (CGSize)intrinsicContentSize {
    return _label.intrinsicContentSize;
}

@end

#pragma mark - -----TTGTextTagCollectionView-----

@interface TTGTextTagCollectionView () <TTGTagCollectionViewDataSource, TTGTagCollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray <TTGTextTagLabel *> *tagLabels;
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

    _defaultConfig = [TTGTextTagConfig new];

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

#pragma mark - Public methods

- (void)reload {
    [self updateAllLabelStyleAndFrame];
    [_tagCollectionView reload];
    [self invalidateIntrinsicContentSize];
}

- (void)addTag:(NSString *)tag {
    [self insertTag:tag atIndex:_tagLabels.count];
}

- (void)addTag:(NSString *)tag withConfig:(TTGTextTagConfig *)config {
    [self insertTag:tag atIndex:_tagLabels.count withConfig:config];
}

- (void)addTags:(NSArray <NSString *> *)tags {
    [self insertTags:tags atIndex:_tagLabels.count withConfig:_defaultConfig copyConfig:NO];
}

- (void)addTags:(NSArray<NSString *> *)tags withConfig:(TTGTextTagConfig *)config {
    [self insertTags:tags atIndex:_tagLabels.count withConfig:config copyConfig:YES];
}

- (void)insertTag:(NSString *)tag atIndex:(NSUInteger)index {
    if ([tag isKindOfClass:[NSString class]]) {
        [self insertTags:@[tag] atIndex:index withConfig:_defaultConfig copyConfig:NO];
    }
}

- (void)insertTag:(NSString *)tag atIndex:(NSUInteger)index withConfig:(TTGTextTagConfig *)config {
    if ([tag isKindOfClass:[NSString class]]) {
        [self insertTags:@[tag] atIndex:index withConfig:config copyConfig:YES];
    }
}

- (void)insertTags:(NSArray<NSString *> *)tags atIndex:(NSUInteger)index {
    [self insertTags:tags atIndex:index withConfig:_defaultConfig copyConfig:NO];
}

- (void)insertTags:(NSArray<NSString *> *)tags atIndex:(NSUInteger)index withConfig:(TTGTextTagConfig *)config {
    [self insertTags:tags atIndex:index withConfig:config copyConfig:YES];
}

- (void)insertTags:(NSArray<NSString *> *)tags atIndex:(NSUInteger)index withConfig:(TTGTextTagConfig *)config copyConfig:(BOOL)copyConfig {
    if (![tags isKindOfClass:[NSArray class]] || index > _tagLabels.count || ![config isKindOfClass:[TTGTextTagConfig class]]) {
        return;
    }
    
    if (copyConfig) {
        config = [config copy];
    }
    
    NSMutableArray *newTagLabels = [NSMutableArray new];
    for (NSString *tagText in tags) {
        TTGTextTagLabel *label = [self newLabelForTagText:[tagText description] withConfig:config];
        [newTagLabels addObject:label];
    }
    [_tagLabels insertObjects:newTagLabels atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, newTagLabels.count)]];
    [self reload];
}

- (void)removeTag:(NSString *)tag {
    if (![tag isKindOfClass:[NSString class]] || tag.length == 0) {
        return;
    }

    NSMutableArray *labelsToRemoved = [NSMutableArray new];
    for (TTGTextTagLabel *label in _tagLabels) {
        if ([label.label.text isEqualToString:tag]) {
            [labelsToRemoved addObject:label];
        }
    }
    [_tagLabels removeObjectsInArray:labelsToRemoved];
    [self reload];
}

- (void)removeTagAtIndex:(NSUInteger)index {
    if (index >= _tagLabels.count) {
        return;
    }

    [_tagLabels removeObjectAtIndex:index];
    [self reload];
}

- (void)removeAllTags {
    [_tagLabels removeAllObjects];
    [self reload];
}

- (void)setTagAtIndex:(NSUInteger)index selected:(BOOL)selected {
    if (index >= _tagLabels.count) {
        return;
    }

    _tagLabels[index].selected = selected;
    [self reload];
}

- (void)setTagAtIndex:(NSUInteger)index withConfig:(TTGTextTagConfig *)config {
    if (index >= _tagLabels.count || ![config isKindOfClass:[TTGTextTagConfig class]]) {
        return;
    }
    
    _tagLabels[index].config = [config copy];
    [self reload];
}

- (void)setTagsInRange:(NSRange)range withConfig:(TTGTextTagConfig *)config {
    if (NSMaxRange(range) > _tagLabels.count || ![config isKindOfClass:[TTGTextTagConfig class]]) {
        return;
    }
    
    NSArray *tagLabels = [_tagLabels subarrayWithRange:range];
    config = [config copy];
    for (TTGTextTagLabel *label in tagLabels) {
        label.config = config;
    }
    [self reload];
}

- (NSString *)getTagAtIndex:(NSUInteger)index {
    if (index < _tagLabels.count) {
        return [_tagLabels[index].label.text copy];
    } else {
        return nil;
    }
}

- (NSArray<NSString *> *)getTagsInRange:(NSRange)range {
    if (NSMaxRange(range) <= _tagLabels.count) {
        NSMutableArray *tags = [NSMutableArray new];
        for (TTGTextTagLabel *label in [_tagLabels subarrayWithRange:range]) {
            [tags addObject:[label.label.text copy]];
        }
        return [tags copy];
    } else {
        return nil;
    }
}

- (TTGTextTagConfig *)getConfigAtIndex:(NSUInteger)index {
    if (index < _tagLabels.count) {
        return [_tagLabels[index].config copy];
    } else {
        return nil;
    }
}

- (NSArray<TTGTextTagConfig *> *)getConfigsInRange:(NSRange)range {
    if (NSMaxRange(range) <= _tagLabels.count) {
        NSMutableArray *configs = [NSMutableArray new];
        for (TTGTextTagLabel *label in [_tagLabels subarrayWithRange:range]) {
            [configs addObject:[label.config copy]];
        }
        return [configs copy];
    } else {
        return nil;
    }
}

- (NSArray <NSString *> *)allTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagLabel *label in _tagLabels) {
        [allTags addObject:[label.label.text copy]];
    }

    return [allTags copy];
}

- (NSArray <NSString *> *)allSelectedTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagLabel *label in _tagLabels) {
        if (label.selected) {
            [allTags addObject:[label.label.text copy]];
        }
    }

    return [allTags copy];
}

- (NSArray <NSString *> *)allNotSelectedTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagLabel *label in _tagLabels) {
        if (!label.selected) {
            [allTags addObject:[label.label.text copy]];
        }
    }

    return [allTags copy];
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
        TTGTextTagLabel *label = _tagLabels[index];
        
        if ([self.delegate respondsToSelector:@selector(textTagCollectionView:canTapTag:atIndex:currentSelected:)]) {
            return [self.delegate textTagCollectionView:self canTapTag:label.label.text atIndex:index currentSelected:label.selected];
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index {
    if (_enableTagSelection) {
        TTGTextTagLabel *label = _tagLabels[index];
        
        if (!label.selected && _selectionLimit > 0 && [self allSelectedTags].count + 1 > _selectionLimit) {
            return;
        }
        
        label.selected = !label.selected;
        
        if (self.alignment == TTGTagCollectionAlignmentFillByExpandingWidth) {
            [self reload];
        } else {
            [self updateStyleAndFrameForLabel:label];
        }
        
        if ([_delegate respondsToSelector:@selector(textTagCollectionView:didTapTag:atIndex:selected:)]) {
            [_delegate textTagCollectionView:self didTapTag:label.label.text atIndex:index selected:label.selected];
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

#pragma mark - Private methods

- (void)updateAllLabelStyleAndFrame {
    for (TTGTextTagLabel *label in _tagLabels) {
        [self updateStyleAndFrameForLabel:label];
    }
}

- (void)updateStyleAndFrameForLabel:(TTGTextTagLabel *)label {
    // Update style
    TTGTextTagConfig *config = label.config;
    label.label.font = config.tagTextFont;
    label.label.textColor = label.selected ? config.tagSelectedTextColor : config.tagTextColor;
    label.label.backgroundColor = label.selected ? config.tagSelectedBackgroundColor : config.tagBackgroundColor;
    label.label.layer.cornerRadius = label.selected ? config.tagSelectedCornerRadius : config.tagCornerRadius;
    label.label.layer.borderWidth = label.selected ? config.tagSelectedBorderWidth : config.tagBorderWidth;
    label.label.layer.borderColor = (label.selected && config.tagSelectedBorderColor) ? config.tagSelectedBorderColor.CGColor : config.tagBorderColor.CGColor;
    label.label.layer.masksToBounds = YES;
    
    label.layer.shadowColor = (config.tagShadowColor ?: [UIColor clearColor]).CGColor;
    label.layer.shadowOffset = config.tagShadowOffset;
    label.layer.shadowRadius = config.tagShadowRadius;
    label.layer.shadowOpacity = config.tagShadowOpacity;
    label.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds cornerRadius:label.label.layer.cornerRadius].CGPath;
    label.layer.shouldRasterize = YES;
    [label.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    
    // Update frame
    CGSize size = [label sizeThatFits:CGSizeZero];
    size.width += config.tagExtraSpace.width;
    size.height += config.tagExtraSpace.height;
    
    // Width limit for vertical scroll direction
    if (self.scrollDirection == TTGTagCollectionScrollDirectionVertical &&
        size.width > (CGRectGetWidth(self.bounds) - self.contentInset.left - self.contentInset.right)) {
        size.width = (CGRectGetWidth(self.bounds) - self.contentInset.left - self.contentInset.right);
    }
    
    label.frame = (CGRect){label.frame.origin, size};
}

- (TTGTextTagLabel *)newLabelForTagText:(NSString *)tagText withConfig:(TTGTextTagConfig *)config {
    TTGTextTagLabel *label = [TTGTextTagLabel new];
    label.label.text = tagText;
    label.config = config;
    [self updateStyleAndFrameForLabel:label];
    return label;
}

@end
