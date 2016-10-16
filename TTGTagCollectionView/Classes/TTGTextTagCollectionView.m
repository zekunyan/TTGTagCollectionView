//
// Created by zorro on 15/12/28.
//

#import "TTGTextTagCollectionView.h"

#pragma mark - -----TTGTextTagLabel-----

@interface TTGTextTagLabel : UILabel
@property (assign, nonatomic) BOOL selected;
@property (assign, nonatomic) NSUInteger index;
@end

@implementation TTGTextTagLabel
@end

#pragma mark - -----TTGTextTagCollectionView-----

@interface TTGTextTagCollectionView () <TTGTagCollectionViewDataSource, TTGTagCollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray <TTGTextTagLabel *> *tagLabels;
@property (strong, nonatomic) TTGTagCollectionView *tagCollectionView;

// Flag
@property (assign, nonatomic) BOOL tagSelectedBorderWidthHasBeenConfigured;
@property (assign, nonatomic) BOOL tagSelectedCornerRadiusHasBeenConfigured;
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

    _tagTextFont = [UIFont systemFontOfSize:18.0f];
    _tagTextColor = [UIColor lightGrayColor];
    _tagSelectedTextColor = [UIColor whiteColor];
    _extraSpace = CGSizeMake(8, 8);
    _tagBackgroundColor = [UIColor whiteColor];
    _tagSelectedBackgroundColor = [UIColor colorWithRed:3 / 256.0f green:169 / 256.0f blue:244 / 256.0f alpha:1];
    _tagCornerRadius = 4.0f;
    _tagBorderWidth = 1.0f / [UIScreen mainScreen].scale;
    _tagBorderColor = [UIColor lightGrayColor];

    _tagCollectionView = [TTGTagCollectionView new];
    _tagCollectionView.delegate = self;
    _tagCollectionView.dataSource = self;
    [self addSubview:_tagCollectionView];
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    _tagCollectionView.frame = self.bounds;
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize {
    return [_tagCollectionView intrinsicContentSize];
}

#pragma mark - Public methods

- (void)reload {
    [_tagCollectionView reload];
}

- (void)addTag:(NSString *)tag {
    if (!tag || tag.length == 0) {
        return;
    }

    TTGTextTagLabel *label = [self newLabelForTagText:tag];
    [_tagLabels addObject:label];
    [_tagCollectionView reload];
}

- (void)addTags:(NSArray <NSString *> *)tags {
    if (!tags) {
        return;
    }

    for (NSString *tagText in tags) {
        TTGTextTagLabel *label = [self newLabelForTagText:tagText];
        [_tagLabels addObject:label];
    }
    [_tagCollectionView reload];
}

- (void)removeTag:(NSString *)tag {
    if (!tag || tag.length == 0) {
        return;
    }

    NSMutableArray *labelsToRemoved = [NSMutableArray new];
    for (TTGTextTagLabel *label in _tagLabels) {
        if ([label.text isEqualToString:tag]) {
            [labelsToRemoved addObject:label];
        }
    }
    [_tagLabels removeObjectsInArray:labelsToRemoved];

    [_tagCollectionView reload];
}

- (void)removeTagAtIndex:(NSUInteger)index {
    if (index >= _tagLabels.count) {
        return;
    }

    [_tagLabels removeObjectAtIndex:index];
    [_tagCollectionView reload];
}

- (void)removeAllTags {
    [_tagLabels removeAllObjects];
    [_tagCollectionView reload];
}

- (void)setTagAtIndex:(NSUInteger)index selected:(BOOL)selected {
    if (index >= _tagLabels.count) {
        return;
    }

    _tagLabels[index].selected = selected;
    [self resetStyleForLabel:_tagLabels[index]];
    [_tagCollectionView reload];
}

- (NSArray <NSString *> *)allTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagLabel *label in _tagLabels) {
        [allTags addObject:label.text];
    }

    return allTags.copy;
}

- (NSArray <NSString *> *)allSelectedTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagLabel *label in _tagLabels) {
        if (label.selected) {
            [allTags addObject:label.text];
        }
    }

    return allTags.copy;
}

- (NSArray <NSString *> *)allNotSelectedTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagLabel *label in _tagLabels) {
        if (!label.selected) {
            [allTags addObject:label.text];
        }
    }

    return allTags.copy;
}

#pragma mark - TTGTagCollectionViewDataSource

- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView {
    return _tagLabels.count;
}

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index {
    TTGTextTagLabel *label = _tagLabels[index];
    label.index = index;
    return _tagLabels[index];
}

#pragma mark - TTGTagCollectionViewDelegate

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index {
    TTGTextTagLabel *label = _tagLabels[index];

    if (_enableTagSelection) {
        label.selected = !label.selected;
        [self resetStyleForLabel:label];
    }

    if ([_delegate respondsToSelector:@selector(textTagCollectionView:didTapTag:atIndex:selected:)]) {
        [_delegate textTagCollectionView:self didTapTag:label.text atIndex:index selected:label.selected];
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

#pragma mark - Setter

// Font

- (void)setTagTextFont:(UIFont *)tagTextFont {
    _tagTextFont = tagTextFont;
    [self resetAllLabelStyle];
    [self resetAllLabelFrame];
}

// Text color

- (void)setTagTextColor:(UIColor *)tagTextColor {
    _tagTextColor = tagTextColor;
    [self resetAllLabelStyle];
}

- (void)setTagSelectedTextColor:(UIColor *)tagSelectedTextColor {
    _tagSelectedTextColor = tagSelectedTextColor;
    [self resetAllLabelStyle];
}

// Background color

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor {
    _tagBackgroundColor = tagBackgroundColor;
    [self resetAllLabelStyle];
}

- (void)setTagSelectedBackgroundColor:(UIColor *)tagSelectedBackgroundColor {
    _tagSelectedBackgroundColor = tagSelectedBackgroundColor;
    [self resetAllLabelStyle];
}

// Corner radius

- (void)setTagCornerRadius:(CGFloat)tagCornerRadius {
    _tagCornerRadius = tagCornerRadius;
    [self resetAllLabelStyle];
}

- (void)setTagSelectedCornerRadius:(CGFloat)tagSelectedCornerRadius {
    _tagSelectedCornerRadius = tagSelectedCornerRadius;
    _tagSelectedCornerRadiusHasBeenConfigured = YES;
    [self resetAllLabelStyle];
}

// Border

- (void)setTagBorderWidth:(CGFloat)tagBorderWidth {
    _tagBorderWidth = tagBorderWidth;
    [self resetAllLabelStyle];
}

- (void)setTagSelectedBorderWidth:(CGFloat)tagSelectedBorderWidth {
    _tagSelectedBorderWidth = tagSelectedBorderWidth;
    _tagSelectedBorderWidthHasBeenConfigured = YES;
    [self resetAllLabelStyle];
}

- (void)setTagBorderColor:(UIColor *)tagBorderColor {
    _tagBorderColor = tagBorderColor;
    [self resetAllLabelStyle];
}

- (void)setTagSelectedBorderColor:(UIColor *)tagSelectedBorderColor {
    _tagSelectedBorderColor = tagSelectedBorderColor;
    [self resetAllLabelStyle];
}

// Other

- (void)setExtraSpace:(CGSize)extraSpace {
    _extraSpace = extraSpace;
    [self resetAllLabelStyle];
    [self resetAllLabelFrame];
}

- (void)setEnableTagSelection:(BOOL)enableTagSelection {
    _enableTagSelection = enableTagSelection;
    [self resetAllLabelStyle];
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

- (NSUInteger)numberOfLinesForHorizontalScrollDirection {
    return _tagCollectionView.numberOfLinesForHorizontalScrollDirection;
}

- (void)setNumberOfLinesForHorizontalScrollDirection:(NSUInteger)numberOfLinesForHorizontalScrollDirection {
    _tagCollectionView.numberOfLinesForHorizontalScrollDirection = numberOfLinesForHorizontalScrollDirection;
}

#pragma mark - Private methods

- (void)resetAllLabelStyle {
    for (TTGTextTagLabel *label in _tagLabels) {
        [self resetStyleForLabel:label];
    }
    [_tagCollectionView reload];
}

- (void)resetAllLabelFrame {
    for (TTGTextTagLabel *label in _tagLabels) {
        [self resetFrameForLabel:label];
    }
    [_tagCollectionView reload];
}

- (void)resetStyleForLabel:(TTGTextTagLabel *)label {
    label.font = _tagTextFont;
    label.textColor = label.selected ? _tagSelectedTextColor : _tagTextColor;
    label.backgroundColor = label.selected ? _tagSelectedBackgroundColor : _tagBackgroundColor;
    label.layer.cornerRadius = (label.selected && _tagSelectedCornerRadiusHasBeenConfigured) ? _tagSelectedCornerRadius : _tagCornerRadius;
    label.layer.borderWidth = (label.selected && _tagSelectedBorderWidthHasBeenConfigured) ? _tagSelectedBorderWidth : _tagBorderWidth;
    label.layer.borderColor = (label.selected && _tagSelectedBorderColor) ? _tagSelectedBorderColor.CGColor : _tagBorderColor.CGColor;
}

- (void)resetFrameForLabel:(UILabel *)label {
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.size.width += _extraSpace.width;
    frame.size.height += _extraSpace.height;
    label.frame = frame;
}

- (TTGTextTagLabel *)newLabelForTagText:(NSString *)tagText {
    TTGTextTagLabel *label = [TTGTextTagLabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = tagText;
    label.layer.masksToBounds = YES;

    [self resetStyleForLabel:label];
    [self resetFrameForLabel:label];

    return label;
}

@end
