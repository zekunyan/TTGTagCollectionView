//
// Created by zorro on 15/12/28.
//

#import "TTGTextTagCollectionView.h"
#import "TTGTagCollectionView.h"
#import "TTGTagCollectionUtil.h"

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
    _tagBorderWidth = 1.0f;
    _tagBorderColor = [UIColor lightGrayColor];

    _horizontalSpacing = 4.0f;
    _verticalSpacing = 4.0f;

    _tagCollectionView = [TTGTagCollectionView new];
    _tagCollectionView.delegate = self;
    _tagCollectionView.dataSource = self;
    _tagCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_tagCollectionView];
    [self addConstraints:[TTGTagCollectionUtil edgeConstraintsWithView1:_tagCollectionView view2:self]];
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
    [self resetLabel:_tagLabels[index]];
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
        [self resetLabel:label];
    }

    if ([_delegate respondsToSelector:@selector(textTagCollectionView:didTapTag:atIndex:selected:)]) {
        [_delegate textTagCollectionView:self didTapTag:label.text atIndex:index selected:label.selected];
    }
}

- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index {
    return _tagLabels[index].frame.size;
}

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView updateContentHeight:(CGFloat)newContentHeight {
    if ([_delegate respondsToSelector:@selector(textTagCollectionView:updateContentHeight:)]) {
        [_delegate textTagCollectionView:self updateContentHeight:newContentHeight];
    }
}

#pragma mark - Setter

- (void)setTagTextFont:(UIFont *)tagTextFont {
    _tagTextFont = tagTextFont;
    [self refreshAllLabels];
}

- (void)setTagTextColor:(UIColor *)tagTextColor {
    _tagTextColor = tagTextColor;
    [self refreshAllLabels];
}

- (void)setTagSelectedTextColor:(UIColor *)tagSelectedTextColor {
    _tagSelectedTextColor = tagSelectedTextColor;
    [self refreshAllLabels];
}

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor {
    _tagBackgroundColor = tagBackgroundColor;
    [self refreshAllLabels];
}

- (void)setTagSelectedBackgroundColor:(UIColor *)tagSelectedBackgroundColor {
    _tagSelectedBackgroundColor = tagSelectedBackgroundColor;
    [self refreshAllLabels];
}

- (void)setTagCornerRadius:(CGFloat)tagCornerRadius {
    _tagCornerRadius = tagCornerRadius;
    [self refreshAllLabels];
}

- (void)setTagBorderWidth:(CGFloat)tagBorderWidth {
    _tagBorderWidth = tagBorderWidth;
    [self refreshAllLabels];
}

- (void)setTagBorderColor:(UIColor *)tagBorderColor {
    _tagBorderColor = tagBorderColor;
    [self refreshAllLabels];
}

- (void)setExtraSpace:(CGSize)extraSpace {
    _extraSpace = extraSpace;
    [self refreshAllLabels];
}

- (void)setEnableTagSelection:(BOOL)enableTagSelection {
    _enableTagSelection = enableTagSelection;
    [self refreshAllLabels];
}

- (void)setHorizontalSpacing:(CGFloat)horizontalSpacing {
    _horizontalSpacing = horizontalSpacing;
    _tagCollectionView.horizontalSpacing = horizontalSpacing;
    [_tagCollectionView reload];
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing {
    _verticalSpacing = verticalSpacing;
    _tagCollectionView.verticalSpacing = verticalSpacing;
    [_tagCollectionView reload];
}

#pragma mark - Private methods

- (void)refreshAllLabels {
    for (TTGTextTagLabel *label in _tagLabels) {
        [self resetLabel:label];
    }
    [_tagCollectionView reload];
}

- (void)resetLabel:(TTGTextTagLabel *)label {
    // Reset property
    label.font = _tagTextFont;
    label.textColor = label.selected ? _tagSelectedTextColor : _tagTextColor;
    label.backgroundColor = label.selected ? _tagSelectedBackgroundColor : _tagBackgroundColor;
    label.layer.cornerRadius = _tagCornerRadius;
    label.layer.borderWidth = _tagBorderWidth;
    label.layer.borderColor = _tagBorderColor.CGColor;

    // Resize
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

    [self resetLabel:label];

    return label;
}

@end