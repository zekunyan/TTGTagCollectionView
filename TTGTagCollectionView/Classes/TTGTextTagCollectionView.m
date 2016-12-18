//
// Created by zorro on 15/12/28.
//

#import "TTGTextTagCollectionView.h"

#pragma mark - -----TTGTextTagLabel-----

@interface TTGTextTagLabel : UIView
@property (nonatomic, strong) UILabel *label;
@property (assign, nonatomic) BOOL selected;
@property (assign, nonatomic) NSUInteger index;
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

    _tagTextFont = [UIFont systemFontOfSize:20.0f];
    
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
        _tagCollectionView.frame = self.bounds;
        [self reload];
    }
}

#pragma mark - Public methods

- (void)reload {
    [self updateAllLabelStyleAndFrame];
    [_tagCollectionView reload];
    [self invalidateIntrinsicContentSize];
}

- (void)addTag:(NSString *)tag {
    if (!tag || tag.length == 0) {
        return;
    }

    TTGTextTagLabel *label = [self newLabelForTagText:tag];
    [_tagLabels addObject:label];
    [self reload];
}

- (void)addTags:(NSArray <NSString *> *)tags {
    if (!tags) {
        return;
    }

    for (NSString *tagText in tags) {
        TTGTextTagLabel *label = [self newLabelForTagText:tagText];
        [_tagLabels addObject:label];
    }
    [self reload];
}

- (void)removeTag:(NSString *)tag {
    if (!tag || tag.length == 0) {
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
    [self updateStyleAndFrameForLabel:_tagLabels[index]];
}

- (NSArray <NSString *> *)allTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagLabel *label in _tagLabels) {
        [allTags addObject:label.label.text];
    }

    return allTags.copy;
}

- (NSArray <NSString *> *)allSelectedTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagLabel *label in _tagLabels) {
        if (label.selected) {
            [allTags addObject:label.label.text];
        }
    }

    return allTags.copy;
}

- (NSArray <NSString *> *)allNotSelectedTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (TTGTextTagLabel *label in _tagLabels) {
        if (!label.selected) {
            [allTags addObject:label.label.text];
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
        [self updateStyleAndFrameForLabel:label];
    }

    if ([_delegate respondsToSelector:@selector(textTagCollectionView:didTapTag:atIndex:selected:)]) {
        [_delegate textTagCollectionView:self didTapTag:label.label.text atIndex:index selected:label.selected];
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

#pragma mark - Private methods

- (void)updateAllLabelStyleAndFrame {
    for (TTGTextTagLabel *label in _tagLabels) {
        [self updateStyleAndFrameForLabel:label];
    }
    [_tagCollectionView reload];
}

- (void)updateStyleAndFrameForLabel:(TTGTextTagLabel *)label {
    // Update style
    label.label.font = _tagTextFont;
    label.label.textColor = label.selected ? _tagSelectedTextColor : _tagTextColor;
    label.label.backgroundColor = label.selected ? _tagSelectedBackgroundColor : _tagBackgroundColor;
    label.label.layer.cornerRadius = label.selected ? _tagSelectedCornerRadius : _tagCornerRadius;
    label.label.layer.borderWidth = label.selected ? _tagSelectedBorderWidth : _tagBorderWidth;
    label.label.layer.borderColor = (label.selected && _tagSelectedBorderColor) ? _tagSelectedBorderColor.CGColor : _tagBorderColor.CGColor;
    label.label.layer.masksToBounds = YES;
    
    label.layer.shadowColor = (_tagShadowColor ?: [UIColor clearColor]).CGColor;
    label.layer.shadowOffset = _tagShadowOffset;
    label.layer.shadowRadius = _tagShadowRadius;
    label.layer.shadowOpacity = _tagShadowOpacity;
    
    // Update frame
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.size.width += _tagExtraSpace.width;
    frame.size.height += _tagExtraSpace.height;
    
    // Width limit for vertical scroll direction
    if (self.scrollDirection == TTGTagCollectionScrollDirectionVertical &&
        CGRectGetWidth(frame) > (CGRectGetWidth(self.bounds) - self.contentInset.left - self.contentInset.right)) {
        frame.size.width = (CGRectGetWidth(self.bounds) - self.contentInset.left - self.contentInset.right);
    }
    
    label.frame = frame;
}

- (TTGTextTagLabel *)newLabelForTagText:(NSString *)tagText {
    TTGTextTagLabel *label = [TTGTextTagLabel new];
    label.label.text = tagText;
    [self updateStyleAndFrameForLabel:label];
    return label;
}

@end
