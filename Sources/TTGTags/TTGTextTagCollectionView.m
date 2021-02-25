//
// Created by zorro on 15/12/28.
//

#import "TTGTextTagCollectionView.h"

#pragma mark - -----TTGTextTagConfig-----

@implementation TTGTextTagConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _textFont = [UIFont systemFontOfSize:16.0f];
        
        _textColor = [UIColor whiteColor];
        _selectedTextColor = [UIColor whiteColor];
        
        _backgroundColor = [UIColor colorWithRed:0.30 green:0.72 blue:0.53 alpha:1.00];
        _selectedBackgroundColor = [UIColor colorWithRed:0.22 green:0.29 blue:0.36 alpha:1.00];

        _enableGradientBackground = NO;
        _gradientBackgroundStartColor = [UIColor clearColor];
        _gradientBackgroundEndColor = [UIColor clearColor];
        _selectedGradientBackgroundStartColor = [UIColor clearColor];
        _selectedGradientBackgroundEndColor = [UIColor clearColor];
        _gradientBackgroundStartPoint = CGPointMake(0.5, 0.0);
        _gradientBackgroundEndPoint = CGPointMake(0.5, 1.0);

        _cornerRadius = 4.0f;
        _selectedCornerRadius = 4.0f;
        _cornerTopLeft = true;
        _cornerTopRight = true;
        _cornerBottomLeft = true;
        _cornerBottomRight = true;

        _borderWidth = 1.0f;
        _selectedBorderWidth = 1.0f;
        
        _borderColor = [UIColor whiteColor];
        _selectedBorderColor = [UIColor whiteColor];
        
        _shadowColor = [UIColor blackColor];
        _shadowOffset = CGSizeMake(2, 2);
        _shadowRadius = 2;
        _shadowOpacity = 0.3f;
        
        _extraSpace = CGSizeMake(14, 14);
        _maxWidth = 0.0f;
        _minWidth = 0.0f;
        
        _exactWidth = 0.0f;
        _exactHeight = 0.0f;
        
        _extraData = nil;
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    TTGTextTagConfig *newConfig = [TTGTextTagConfig new];
    newConfig.textFont = [_textFont copyWithZone:zone];
    
    newConfig.textColor = [_textColor copyWithZone:zone];
    newConfig.selectedTextColor = [_selectedTextColor copyWithZone:zone];
    
    newConfig.backgroundColor = [_backgroundColor copyWithZone:zone];
    newConfig.selectedBackgroundColor = [_selectedBackgroundColor copyWithZone:zone];

    newConfig.enableGradientBackground = _enableGradientBackground;
    newConfig.gradientBackgroundStartColor = [_gradientBackgroundStartColor copyWithZone:zone];
    newConfig.gradientBackgroundEndColor = [_gradientBackgroundEndColor copyWithZone:zone];
    newConfig.selectedGradientBackgroundStartColor = [_selectedGradientBackgroundStartColor copyWithZone:zone];
    newConfig.selectedGradientBackgroundEndColor = [_selectedGradientBackgroundEndColor copyWithZone:zone];
    newConfig.gradientBackgroundStartPoint = _gradientBackgroundStartPoint;
    newConfig.gradientBackgroundEndPoint = _gradientBackgroundEndPoint;
    
    newConfig.cornerRadius = _cornerRadius;
    newConfig.selectedCornerRadius = _selectedCornerRadius;
    newConfig.cornerTopLeft = _cornerTopLeft;
    newConfig.cornerTopRight = _cornerTopRight;
    newConfig.cornerBottomLeft = _cornerBottomLeft;
    newConfig.cornerBottomRight = _cornerBottomRight;
    
    newConfig.borderWidth = _borderWidth;
    newConfig.selectedBorderWidth = _selectedBorderWidth;
    
    newConfig.borderColor = [_borderColor copyWithZone:zone];
    newConfig.selectedBorderColor = [_selectedBorderColor copyWithZone:zone];
    
    newConfig.shadowColor = [_shadowColor copyWithZone:zone];
    newConfig.shadowOffset = _shadowOffset;
    newConfig.shadowRadius = _shadowRadius;
    newConfig.shadowOpacity = _shadowOpacity;
    
    newConfig.extraSpace = _extraSpace;
    newConfig.maxWidth = _maxWidth;
    newConfig.minWidth = _minWidth;
    
    newConfig.exactWidth = _exactWidth;
    newConfig.exactHeight = _exactHeight;
    
    if ([_extraData conformsToProtocol:@protocol(NSCopying)] &&
        [_extraData respondsToSelector:@selector(copyWithZone:)]) {
        newConfig.extraData = [((id <NSCopying>)_extraData) copyWithZone:zone];
    } else {
        newConfig.extraData = _extraData;
    }
    
    return newConfig;
}

@end

#pragma mark - -----TTGTextTagLabel-----

#pragma mark - GradientLabel

@interface GradientLabel: UILabel
@end

@implementation GradientLabel
+ (Class)layerClass {
    return [CAGradientLayer class];
}
@end

// UILabel wrapper for round corner and shadow at the same time.
@interface TTGTextTagLabel : UIView
@property (nonatomic, strong) TTGTextTagConfig *config;
@property (nonatomic, strong) GradientLabel *label;
@property (nonatomic, strong) CAShapeLayer *borderLayer;
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
    _label = [[GradientLabel alloc] initWithFrame:self.bounds];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.userInteractionEnabled = YES;
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

- (void)updateContentStyle {
    // Text style
    _label.font = _config.textFont;
    _label.textColor = _selected ? _config.selectedTextColor : _config.textColor;
    
    // Normal background
    _label.backgroundColor = _selected ? _config.selectedBackgroundColor : _config.backgroundColor;
    
    // Gradient background
    if (_config.enableGradientBackground) {
        _label.backgroundColor = [UIColor clearColor];
        if (_selected) {
            ((CAGradientLayer *)_label.layer).colors = @[(id)_config.selectedGradientBackgroundStartColor.CGColor,
                                                         (id)_config.selectedGradientBackgroundEndColor.CGColor];
        } else {
            ((CAGradientLayer *)_label.layer).colors = @[(id)_config.gradientBackgroundStartColor.CGColor,
                                                         (id)_config.gradientBackgroundEndColor.CGColor];
        }
        ((CAGradientLayer *)_label.layer).startPoint = _config.gradientBackgroundStartPoint;
        ((CAGradientLayer *)_label.layer).endPoint = _config.gradientBackgroundEndPoint;
    }
}

- (void)updateFrameWithMaxSize:(CGSize)maxSize {
    [_label sizeToFit];
    
    CGSize finalSize = _label.frame.size;
    
    finalSize.width += _config.extraSpace.width;
    finalSize.height += _config.extraSpace.height;
    
    if (self.config.maxWidth > 0 && finalSize.width > self.config.maxWidth) {
        finalSize.width = self.config.maxWidth;
    }
    if (self.config.minWidth > 0 && finalSize.width < self.config.minWidth) {
        finalSize.width = self.config.minWidth;
    }
    if (self.config.exactWidth > 0) {
        finalSize.width = self.config.exactWidth;
    }
    if (self.config.exactHeight > 0) {
        finalSize.height = self.config.exactHeight;
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
    self.layer.shadowColor = (_config.shadowColor ?: [UIColor clearColor]).CGColor;
    self.layer.shadowOffset = _config.shadowOffset;
    self.layer.shadowRadius = _config.shadowRadius;
    self.layer.shadowOpacity = _config.shadowOpacity;
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
    _borderLayer.fillColor = nil;
    _borderLayer.opacity = 1;
    _borderLayer.lineWidth = _selected ? _config.selectedBorderWidth : _config.borderWidth;
    _borderLayer.strokeColor = (_selected && _config.selectedBorderColor) ? _config.selectedBorderColor.CGColor : _config.borderColor.CGColor;
    [self.layer addSublayer:_borderLayer];
}

- (UIBezierPath *)getNewPath {
    // Round corner
    UIRectCorner corners = (UIRectCorner) -1;
    if (_config.cornerTopLeft) {
        corners = UIRectCornerTopLeft;
    }
    if (_config.cornerTopRight) {
        if (corners == -1) {
            corners = UIRectCornerTopRight;
        } else {
            corners = corners | UIRectCornerTopRight;
        }
    }
    if (_config.cornerBottomLeft) {
        if (corners == -1) {
            corners = UIRectCornerBottomLeft;
        } else {
            corners = corners | UIRectCornerBottomLeft;
        }
    }
    if (_config.cornerBottomRight) {
        if (corners == -1) {
            corners = UIRectCornerBottomRight;
        } else {
            corners = corners | UIRectCornerBottomRight;
        }
    }

    // Corner radius
    CGFloat currentCornerRadius = _selected ? _config.selectedCornerRadius : _config.cornerRadius;
    
    // Path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                               byRoundingCorners:corners
                                                     cornerRadii:CGSizeMake(currentCornerRadius, currentCornerRadius)];
    return path;
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

- (CGSize)sizeThatFits:(CGSize)size {
    return self.contentSize;
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

- (NSInteger)indexOfTagAt:(CGPoint)point {
    // We expect the point to be a point wrt to the TTGTextTagCollectionView.
    // so convert this point first to a point wrt to the TTGTagCollectionView.
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
        TTGTextTagLabel *label = _tagLabels[index];
        
        if ([self.delegate respondsToSelector:@selector(textTagCollectionView:canTapTag:atIndex:currentSelected:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            return [self.delegate textTagCollectionView:self canTapTag:label.label.text atIndex:index currentSelected:label.selected];
#pragma clang diagnostic pop
        } else if ([self.delegate respondsToSelector:@selector(textTagCollectionView:canTapTag:atIndex:currentSelected:tagConfig:)]) {
            return [self.delegate textTagCollectionView:self canTapTag:label.label.text atIndex:index currentSelected:label.selected tagConfig:label.config];
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
        
        if (self.alignment == TTGTagCollectionAlignmentFillByExpandingWidth ||
            self.alignment == TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine) {
            [self reload];
        } else {
            [self updateStyleAndFrameForLabel:label];
        }
        
        if ([_delegate respondsToSelector:@selector(textTagCollectionView:didTapTag:atIndex:selected:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [_delegate textTagCollectionView:self didTapTag:label.label.text atIndex:index selected:label.selected];
#pragma clang diagnostic pop
        }
        
        if ([_delegate respondsToSelector:@selector(textTagCollectionView:didTapTag:atIndex:selected:tagConfig:)]) {
            [_delegate textTagCollectionView:self didTapTag:label.label.text atIndex:index selected:label.selected tagConfig:label.config];
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
    for (TTGTextTagLabel *label in _tagLabels) {
        [self updateStyleAndFrameForLabel:label];
    }
}

- (void)updateStyleAndFrameForLabel:(TTGTextTagLabel *)label {
    // Update content style
    [label updateContentStyle];
    // Width limit for vertical scroll direction
    CGSize maxSize = CGSizeZero;
    if (self.scrollDirection == TTGTagCollectionScrollDirectionVertical &&
        CGRectGetWidth(self.bounds) > 0) {
        maxSize.width = (CGRectGetWidth(self.bounds) - self.contentInset.left - self.contentInset.right);
    }
    // Update frame
    [label updateFrameWithMaxSize:maxSize];
}

- (TTGTextTagLabel *)newLabelForTagText:(NSString *)tagText withConfig:(TTGTextTagConfig *)config {
    TTGTextTagLabel *label = [TTGTextTagLabel new];
    label.label.text = tagText;
    label.config = config;
    return label;
}

@end
