//
//  TTGTagCollectionView.m
//  Pods
//
//  Created by zorro on 15/12/26.
//
//

#import "TTGTagCollectionView.h"

@interface TTGTagCollectionView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL needsLayoutTagViews;
@end

@implementation TTGTagCollectionView

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
    if (_scrollView) {
        return;
    }
    
    _horizontalSpacing = 4;
    _verticalSpacing = 4;
    _contentInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.userInteractionEnabled = YES;
    [self addSubview:_scrollView];
    
    UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
    [tapGesture addTarget:self action:@selector(onTapGesture:)];
    [_scrollView addGestureRecognizer:tapGesture];
    
    [self setNeedsLayoutTagViews];
}

#pragma mark - Public methods

- (void)reload {
    if (![self isDelegateAndDataSourceValid]) {
        return;
    }
    
    // Remove all tag views
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Update tag view frame
    [self setNeedsLayoutTagViews];
    [self layoutTagViews];
    
    // Add tag view
    for (NSUInteger i = 0; i < [_dataSource numberOfTagsInTagCollectionView:self]; i++) {
        [_scrollView addSubview:[_dataSource tagCollectionView:self tagViewForIndex:i]];
    }
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - Gesture

- (void)onTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (![self.dataSource respondsToSelector:@selector(numberOfTagsInTagCollectionView:)] ||
        ![self.delegate respondsToSelector:@selector(tagCollectionView:didSelectTag:atIndex:)]) {
        return;
    }
    
    CGPoint tapPoint = [tapGesture locationInView:_scrollView];
    
    for (NSUInteger i = 0; i < [self.dataSource numberOfTagsInTagCollectionView:self]; i++) {
        UIView *tagView = [self.dataSource tagCollectionView:self tagViewForIndex:i];
        if (CGRectContainsPoint(tagView.frame, tapPoint)) {
            [self.delegate tagCollectionView:self didSelectTag:tagView atIndex:i];
        }
    }
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(_scrollView.frame, self.bounds)) {
        _scrollView.frame = self.bounds;
        [self setNeedsLayoutTagViews];
    }
    
    [self layoutTagViews];
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
    return _scrollView.contentSize;
}

#pragma mark - Layout

- (void)layoutTagViews {
    if (!_needsLayoutTagViews || ![self isDelegateAndDataSourceValid]) {
        return;
    }
    
    if (_scrollDirection == TTGTagCollectionScrollDirectionVertical) {
        [self layoutTagViewsForVerticalDirection];
    } else {
        [self layoutTagViewsForHorizontalDirection];
    }
    
    _needsLayoutTagViews = NO;
}

- (void)layoutTagViewsForVerticalDirection {
    NSUInteger count = [_dataSource numberOfTagsInTagCollectionView:self];
    CGFloat visibleWidth = CGRectGetWidth(self.bounds) - _contentInset.left - _contentInset.right;
    CGFloat currentLineX = 0;
    CGFloat tmpHeight = 0;
    CGRect frame;
    
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineWidthNumbers = [NSMutableArray new];
    
    // Set frame size and get each line max height and width
    for (NSUInteger i = 0; i < count; i++) {
        UIView *tagView = [_dataSource tagCollectionView:self tagViewForIndex:i];
        CGSize tagSize = [_delegate tagCollectionView:self sizeForTagAtIndex:i];
        frame = tagView.frame;
        
        // Vertical scroll direction tagView width limit
        if (self.scrollDirection == TTGTagCollectionScrollDirectionVertical && tagSize.width > visibleWidth) {
            tagSize.width = visibleWidth;
        }

        if (currentLineX + tagSize.width > visibleWidth) {
            // New Line
            [eachLineMaxHeightNumbers addObject:@(tmpHeight)];
            [eachLineWidthNumbers addObject:@(currentLineX - _horizontalSpacing)];
            tmpHeight = 0;
            currentLineX = 0;
        }
        
        // Line number limit
        if (_numberOfLines != 0) {
            tagView.hidden = eachLineWidthNumbers.count >= _numberOfLines;
        }
        
        currentLineX += tagSize.width + _horizontalSpacing;
        tmpHeight = MAX(tagSize.height, tmpHeight);
        
        frame.size = tagSize;
        tagView.frame = frame;
    }
    
    // Add last
    [eachLineMaxHeightNumbers addObject:@(tmpHeight)];
    [eachLineWidthNumbers addObject:@(currentLineX - _horizontalSpacing)];
    
    // Line limit
    if (_numberOfLines != 0) {
        eachLineWidthNumbers = [[eachLineWidthNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineWidthNumbers.count, _numberOfLines))] mutableCopy];
        eachLineMaxHeightNumbers = [[eachLineMaxHeightNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineMaxHeightNumbers.count, _numberOfLines))] mutableCopy];
    }
    
    // Check
    NSAssert(eachLineMaxHeightNumbers.count == eachLineWidthNumbers.count, @"eachLineMaxHeightNumbers and eachLineWidthNumbers not equal.");
    
    // Prepare
    currentLineX = 0;
    CGFloat currentYBase = _contentInset.top;
    NSUInteger currentTagIndex = 0;
    CGFloat currentLineMaxHeight = 0;
    CGFloat currentLineWidth = 0;
    
    // Set X and Y
    for (NSUInteger i = 0; i < eachLineWidthNumbers.count; i++) {
        currentLineWidth = eachLineWidthNumbers[i].floatValue;
        currentLineMaxHeight = eachLineMaxHeightNumbers[i].floatValue;
        
        // Alignment x offset
        CGFloat currentLineXOffset = 0;
        switch (_alignment) {
            case TTGTagCollectionAlignmentLeft:
                currentLineXOffset = _contentInset.left;
                break;
            case TTGTagCollectionAlignmentCenter:
                currentLineXOffset = (visibleWidth - currentLineWidth) / 2 + _contentInset.left;
                break;
            case TTGTagCollectionAlignmentRight:
                currentLineXOffset = visibleWidth - currentLineWidth + _contentInset.left;
                break;
        }
        
        // Current line
        while (currentLineX < currentLineWidth && currentTagIndex < count) {
            UIView *tagView = [_dataSource tagCollectionView:self tagViewForIndex:currentTagIndex];
            frame = tagView.frame;
            
            frame.origin.x = currentLineXOffset + currentLineX;
            frame.origin.y = currentYBase + (currentLineMaxHeight - CGRectGetHeight(frame)) / 2;
            tagView.frame = frame;
            
            currentLineX += CGRectGetWidth(frame) + _horizontalSpacing;
            currentTagIndex += 1;
        }
        
        // Next line
        currentLineX = 0;
        currentYBase += currentLineMaxHeight + _verticalSpacing;
    }
    
    // Content size
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds), currentYBase - _verticalSpacing + _contentInset.bottom);
    if (!CGSizeEqualToSize(contentSize, _scrollView.contentSize)) {
        _scrollView.contentSize = contentSize;
        
        if ([self.delegate respondsToSelector:@selector(tagCollectionView:updateContentSize:)]) {
            [self.delegate tagCollectionView:self updateContentSize:contentSize];
        }
    }
}

- (void)layoutTagViewsForHorizontalDirection {
    CGFloat totalWidthInOneLine = 0, averageWidthEachLine = 0, currentX = _contentInset.left,
        currentYBase = -_verticalSpacing + _contentInset.top, tmpHeight = 0, contentWidth = 0;
    CGRect frame;
    
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineTrueWidthNumbers = [NSMutableArray new];
    NSInteger count = [_dataSource numberOfTagsInTagCollectionView:self];
    _numberOfLines = _numberOfLines == 0 ? 1 : _numberOfLines;
    
    // Set frame size and get totalWidthInOneLine
    for (NSInteger i = 0; i < count; i++) {
        UIView *tagView = [_dataSource tagCollectionView:self tagViewForIndex:i];
        CGSize tagSize = [_delegate tagCollectionView:self sizeForTagAtIndex:i];
        frame = tagView.frame;
        frame.size = tagSize;
        totalWidthInOneLine += tagSize.width + _horizontalSpacing;
        tagView.frame = frame;
    }
    
    // Calculate each line width
    averageWidthEachLine = totalWidthInOneLine / (CGFloat)_numberOfLines;
    
    // Set X and get each line max height
    for (NSInteger i = 0; i < count; i++) {
        UIView *tagView = [_dataSource tagCollectionView:self tagViewForIndex:i];
        frame = tagView.frame;
        frame.origin.x = currentX;
        tagView.frame = frame;
        
        currentX += CGRectGetWidth(frame) + _horizontalSpacing;
        contentWidth = MAX(currentX - _horizontalSpacing, contentWidth);
        tmpHeight = MAX(CGRectGetHeight(frame), tmpHeight);
        
        if (currentX > averageWidthEachLine && eachLineMaxHeightNumbers.count < _numberOfLines) {
            [eachLineMaxHeightNumbers addObject:@(tmpHeight)];
            [eachLineTrueWidthNumbers addObject:@(currentX - _contentInset.left - _horizontalSpacing)];
            tmpHeight = 0;
            currentX = _contentInset.left;
        }
    }
    
    // Add last
    [eachLineMaxHeightNumbers addObject:@(tmpHeight)];
    [eachLineTrueWidthNumbers addObject:@(currentX - _contentInset.left - _horizontalSpacing)];
    
    // Set Y
    NSUInteger currentLineIndex = 0;
    CGFloat currentLineMaxHeight = 0;
    CGFloat currentLineTrueWidth = 0;
    CGFloat currentLineXOffset = 0;
    
    for (NSInteger i = 0; i < count; i++) {
        UIView *tagView = [_dataSource tagCollectionView:self tagViewForIndex:i];
        frame = tagView.frame;
        
        if (frame.origin.x == _contentInset.left && currentLineIndex < eachLineMaxHeightNumbers.count) {
            currentYBase += currentLineMaxHeight + _verticalSpacing;
            currentLineMaxHeight = eachLineMaxHeightNumbers[currentLineIndex].floatValue;
            currentLineTrueWidth = eachLineTrueWidthNumbers[currentLineIndex].floatValue;
            currentLineIndex += 1;
            
            // Calculate x offset
            switch (_alignment) {
                case TTGTagCollectionAlignmentLeft:
                    currentLineXOffset = 0;
                    break;
                case TTGTagCollectionAlignmentCenter:
                    currentLineXOffset = (contentWidth - currentLineTrueWidth - _contentInset.left) / 2;
                    break;
                case TTGTagCollectionAlignmentRight:
                    currentLineXOffset = contentWidth - currentLineTrueWidth - _contentInset.left;
                    break;
            }
        }
        
        frame.origin.y = currentYBase + (currentLineMaxHeight - CGRectGetHeight(frame)) / 2;
        frame.origin.x += currentLineXOffset;
        tagView.frame = frame;
    }
    
    // Content size
    contentWidth += _contentInset.right;
    CGSize contentSize = CGSizeMake(contentWidth, currentYBase + currentLineMaxHeight + _contentInset.bottom);
    if (!CGSizeEqualToSize(contentSize, _scrollView.contentSize)) {
        _scrollView.contentSize = contentSize;
        
        if ([self.delegate respondsToSelector:@selector(tagCollectionView:updateContentSize:)]) {
            [self.delegate tagCollectionView:self updateContentSize:contentSize];
        }
    }
}

- (void)setNeedsLayoutTagViews {
    _needsLayoutTagViews = YES;
}

#pragma mark - Check delegate and dataSource

- (BOOL)isDelegateAndDataSourceValid {
    BOOL isValid = _delegate != nil && _dataSource != nil;
    isValid = isValid && [_delegate respondsToSelector:@selector(tagCollectionView:sizeForTagAtIndex:)];
    isValid = isValid && [_dataSource respondsToSelector:@selector(tagCollectionView:tagViewForIndex:)];
    isValid = isValid && [_dataSource respondsToSelector:@selector(numberOfTagsInTagCollectionView:)];
    return isValid;
}

#pragma mark - Setter Getter

- (void)setScrollDirection:(TTGTagCollectionScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    [self setNeedsLayoutTagViews];
}

- (void)setAlignment:(TTGTagCollectionAlignment)alignment {
    _alignment = alignment;
    [self setNeedsLayoutTagViews];
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    [self setNeedsLayoutTagViews];
}

- (void)setHorizontalSpacing:(CGFloat)horizontalSpacing {
    _horizontalSpacing = horizontalSpacing;
    [self setNeedsLayoutTagViews];
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing {
    _verticalSpacing = verticalSpacing;
    [self setNeedsLayoutTagViews];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self setNeedsLayoutTagViews];
}

@end
