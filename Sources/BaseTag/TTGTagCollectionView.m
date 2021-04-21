//
//  TTGTagCollectionView.m
//  Pods
//
//  Created by zekunyan on 15/12/26.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

#if SWIFT_PACKAGE
#import "TTGTagCollectionView.h"
#else
#import <TTGTagCollectionView/TTGTagCollectionView.h>
#endif

@interface TTGTagCollectionView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL needsLayoutTagViews;
@property (nonatomic, assign) NSUInteger actualNumberOfLines;
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
    
    _containerView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.userInteractionEnabled = YES;
    [_scrollView addSubview:_containerView];
    
    UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
    [tapGesture addTarget:self action:@selector(onTapGesture:)];
    [_containerView addGestureRecognizer:tapGesture];
    
    [self setNeedsLayoutTagViews];
}

#pragma mark - Public methods

- (void)reload {
    if (![self isDelegateAndDataSourceValid]) {
        return;
    }
    
    // Remove all tag views
    [_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Add tag view
    for (NSUInteger i = 0; i < [_dataSource numberOfTagsInTagCollectionView:self]; i++) {
        [_containerView addSubview:[_dataSource tagCollectionView:self tagViewForIndex:i]];
    }
    
    // Update tag view frame
    [self setNeedsLayoutTagViews];
    [self layoutTagViews];
}

- (NSInteger)indexOfTagAt:(CGPoint)point {
    // We expect the point to be a point wrt to the TTGTagCollectionView.
    // so convert this point first to a point wrt to the container view.
    CGPoint convertedPoint = [self convertPoint:point toView:_containerView];
    for (NSUInteger i = 0; i < [self.dataSource numberOfTagsInTagCollectionView:self]; i++) {
        UIView *tagView = [self.dataSource tagCollectionView:self tagViewForIndex:i];
        if (CGRectContainsPoint(tagView.frame, convertedPoint) && !tagView.isHidden) {
            return i;
        }
    }
    return NSNotFound;
}

#pragma mark - Gesture

- (void)onTapGesture:(UITapGestureRecognizer *)tapGesture {
    CGPoint tapPointInCollectionView = [tapGesture locationInView:self];
    
    if (![self.dataSource respondsToSelector:@selector(numberOfTagsInTagCollectionView:)] ||
        ![self.dataSource respondsToSelector:@selector(tagCollectionView:tagViewForIndex:)] ||
        ![self.delegate respondsToSelector:@selector(tagCollectionView:didSelectTag:atIndex:)]) {
        if (_onTapBlankArea) {
            _onTapBlankArea(tapPointInCollectionView);
        }
        if (_onTapAllArea) {
            _onTapAllArea(tapPointInCollectionView);
        }
        return;
    }
    
    CGPoint tapPointInScrollView = [tapGesture locationInView:_containerView];
    BOOL hasLocatedToTag = NO;
    
    for (NSUInteger i = 0; i < [self.dataSource numberOfTagsInTagCollectionView:self]; i++) {
        UIView *tagView = [self.dataSource tagCollectionView:self tagViewForIndex:i];
        if (CGRectContainsPoint(tagView.frame, tapPointInScrollView) && !tagView.isHidden) {
            hasLocatedToTag = YES;
            if ([self.delegate respondsToSelector:@selector(tagCollectionView:shouldSelectTag:atIndex:)]) {
                if ([self.delegate tagCollectionView:self shouldSelectTag:tagView atIndex:i]) {
                    [self.delegate tagCollectionView:self didSelectTag:tagView atIndex:i];
                }
            } else {
                [self.delegate tagCollectionView:self didSelectTag:tagView atIndex:i];
            }
        }
    }
    
    if (!hasLocatedToTag) {
        if (_onTapBlankArea) {
            _onTapBlankArea(tapPointInCollectionView);
        }
    }
    if (_onTapAllArea) {
        _onTapAllArea(tapPointInCollectionView);
    }
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(_scrollView.frame, self.bounds)) {
        _scrollView.frame = self.bounds;
        [self setNeedsLayoutTagViews];
        [self layoutTagViews];
        _containerView.frame = (CGRect){CGPointZero, _scrollView.contentSize};
    }
    [self layoutTagViews];
}

- (CGSize)intrinsicContentSize {
    return _scrollView.contentSize;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return self.contentSize;
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
    [self invalidateIntrinsicContentSize];
}

- (void)layoutTagViewsForVerticalDirection {
    NSUInteger count = [_dataSource numberOfTagsInTagCollectionView:self];
    NSUInteger currentLineTagsCount = 0;
    CGFloat totalWidth = (_manualCalculateHeight && _preferredMaxLayoutWidth > 0) ? _preferredMaxLayoutWidth : CGRectGetWidth(self.bounds);
    CGFloat maxLineWidth = totalWidth - _contentInset.left - _contentInset.right;
    CGFloat currentLineX = 0;
    CGFloat currentLineMaxHeight = 0;
    
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineWidthNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineTagCountNumbers = [NSMutableArray new];
    
    NSMutableArray <NSArray <NSNumber *> *> *eachLineTagIndexs = [NSMutableArray new];
    NSMutableArray <NSNumber *> *tmpTagIndexNumbers = [NSMutableArray new];
    
    // Get each line max height ,width and tag count
    for (NSUInteger i = 0; i < count; i++) {
        CGSize tagSize = [_delegate tagCollectionView:self sizeForTagAtIndex:i];

        if (currentLineX + tagSize.width > maxLineWidth && tmpTagIndexNumbers.count > 0) {
            // New Line
            [eachLineMaxHeightNumbers addObject:@(currentLineMaxHeight)];
            [eachLineWidthNumbers addObject:@(currentLineX - _horizontalSpacing)];
            [eachLineTagCountNumbers addObject:@(currentLineTagsCount)];
            [eachLineTagIndexs addObject:tmpTagIndexNumbers];
            tmpTagIndexNumbers = [NSMutableArray new];
            currentLineTagsCount = 0;
            currentLineMaxHeight = 0;
            currentLineX = 0;
        }
        
        // Line limit
        if (_numberOfLines != 0) {
            UIView *tagView = [_dataSource tagCollectionView:self tagViewForIndex:i];
            tagView.hidden = eachLineWidthNumbers.count >= _numberOfLines;
        }
        
        currentLineX += tagSize.width + _horizontalSpacing;
        currentLineTagsCount += 1;
        currentLineMaxHeight = MAX(tagSize.height, currentLineMaxHeight);
        [tmpTagIndexNumbers addObject:@(i)];
    }
    
    // Add last
    [eachLineMaxHeightNumbers addObject:@(currentLineMaxHeight)];
    [eachLineWidthNumbers addObject:@(currentLineX - _horizontalSpacing)];
    [eachLineTagCountNumbers addObject:@(currentLineTagsCount)];
    [eachLineTagIndexs addObject:tmpTagIndexNumbers];
    
    // Actual number of lines
    _actualNumberOfLines = eachLineTagCountNumbers.count;
    
    // Line limit
    if (_numberOfLines != 0) {
        eachLineMaxHeightNumbers = [[eachLineMaxHeightNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineMaxHeightNumbers.count, _numberOfLines))] mutableCopy];
        eachLineWidthNumbers = [[eachLineWidthNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineWidthNumbers.count, _numberOfLines))] mutableCopy];
        eachLineTagCountNumbers = [[eachLineTagCountNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineTagCountNumbers.count, _numberOfLines))] mutableCopy];
        eachLineTagIndexs = [[eachLineTagIndexs subarrayWithRange:NSMakeRange(0, MIN(eachLineTagIndexs.count, _numberOfLines))] mutableCopy];
    }
    
    // Prepare
    [self layoutEachLineTagsWithMaxLineWidth:maxLineWidth
                               numberOfLines:eachLineTagCountNumbers.count
                           eachLineTagIndexs:eachLineTagIndexs
                            eachLineTagCount:eachLineTagCountNumbers
                               eachLineWidth:eachLineWidthNumbers
                           eachLineMaxHeight:eachLineMaxHeightNumbers];
}

- (void)layoutTagViewsForHorizontalDirection {
    NSInteger count = [_dataSource numberOfTagsInTagCollectionView:self];
    _numberOfLines = _numberOfLines == 0 ? 1 : _numberOfLines;
    _numberOfLines = MIN(count, _numberOfLines);
    
    CGFloat maxLineWidth = 0;
    
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineWidthNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineTagCountNumbers = [NSMutableArray new];
    
    NSMutableArray <NSMutableArray <NSNumber *> *> *eachLineTagIndexs = [NSMutableArray new];
    
    // Init each line
    for (NSInteger currentLine = 0; currentLine < _numberOfLines; currentLine++) {
        [eachLineMaxHeightNumbers addObject:@0];
        [eachLineWidthNumbers addObject:@0];
        [eachLineTagCountNumbers addObject:@0];
        [eachLineTagIndexs addObject:[NSMutableArray new]];
    }
    
    // Add tags
    for (NSUInteger tagIndex = 0; tagIndex < count; tagIndex++) {
        NSUInteger currentLine = tagIndex % _numberOfLines;
        
        NSUInteger currentLineTagsCount = eachLineTagCountNumbers[currentLine].unsignedIntegerValue;
        CGFloat currentLineMaxHeight = eachLineMaxHeightNumbers[currentLine].floatValue;
        CGFloat currentLineX = eachLineWidthNumbers[currentLine].floatValue;
        NSMutableArray *currentLineTagIndexNumbers = eachLineTagIndexs[currentLine];
        
        CGSize tagSize = [_delegate tagCollectionView:self sizeForTagAtIndex:tagIndex];
        currentLineX += tagSize.width + _horizontalSpacing;
        currentLineMaxHeight = MAX(tagSize.height, currentLineMaxHeight);
        currentLineTagsCount += 1;
        [currentLineTagIndexNumbers addObject:@(tagIndex)];
        
        eachLineTagCountNumbers[currentLine] = @(currentLineTagsCount);
        eachLineMaxHeightNumbers[currentLine] = @(currentLineMaxHeight);
        eachLineWidthNumbers[currentLine] = @(currentLineX);
        eachLineTagIndexs[currentLine] = currentLineTagIndexNumbers;
    }
    
    // Remove extra space
    for (NSInteger currentLine = 0; currentLine < _numberOfLines; currentLine++) {
        CGFloat currentLineWidth = eachLineWidthNumbers[currentLine].floatValue;
        currentLineWidth -= _horizontalSpacing;
        eachLineWidthNumbers[currentLine] = @(currentLineWidth);
        
        maxLineWidth = MAX(currentLineWidth, maxLineWidth);
    }
    
    // Prepare
    [self layoutEachLineTagsWithMaxLineWidth:maxLineWidth
                               numberOfLines:eachLineTagCountNumbers.count
                           eachLineTagIndexs:eachLineTagIndexs
                            eachLineTagCount:eachLineTagCountNumbers
                               eachLineWidth:eachLineWidthNumbers
                           eachLineMaxHeight:eachLineMaxHeightNumbers];
}

- (void)layoutEachLineTagsWithMaxLineWidth:(CGFloat)maxLineWidth
                             numberOfLines:(NSUInteger)numberOfLines
                         eachLineTagIndexs:(NSArray <NSArray <NSNumber *> *> *)eachLineTagIndexs
                          eachLineTagCount:(NSArray <NSNumber *> *)eachLineTagCount
                             eachLineWidth:(NSArray <NSNumber *> *)eachLineWidth
                         eachLineMaxHeight:(NSArray <NSNumber *> *)eachLineMaxHeight {
 
    CGFloat currentYBase = _contentInset.top;
    
    for (NSUInteger currentLine = 0; currentLine < numberOfLines; currentLine++) {
        CGFloat currentLineMaxHeight = eachLineMaxHeight[currentLine].floatValue;
        CGFloat currentLineWidth = eachLineWidth[currentLine].floatValue;
        CGFloat currentLineTagsCount = eachLineTagCount[currentLine].unsignedIntegerValue;
        
        // Alignment x offset
        CGFloat currentLineXOffset = 0;
        CGFloat currentLineAdditionWidth = 0;
        CGFloat acturalHorizontalSpacing = _horizontalSpacing;
        __block CGFloat currentLineX = 0;
        
        switch (_alignment) {
            case TTGTagCollectionAlignmentLeft:
                currentLineXOffset = _contentInset.left;
                break;
            case TTGTagCollectionAlignmentCenter:
                currentLineXOffset = (maxLineWidth - currentLineWidth) / 2 + _contentInset.left;
                break;
            case TTGTagCollectionAlignmentRight:
                currentLineXOffset = maxLineWidth - currentLineWidth + _contentInset.left;
                break;
            case TTGTagCollectionAlignmentFillByExpandingSpace:
                currentLineXOffset = _contentInset.left;
                acturalHorizontalSpacing = _horizontalSpacing +
                (maxLineWidth - currentLineWidth) / (CGFloat)(currentLineTagsCount - 1);
                currentLineWidth = maxLineWidth;
                break;
            case TTGTagCollectionAlignmentFillByExpandingWidth:
            case TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine:
                currentLineXOffset = _contentInset.left;
                currentLineAdditionWidth = (maxLineWidth - currentLineWidth) / (CGFloat)currentLineTagsCount;
                currentLineWidth = maxLineWidth;
                
                if (_alignment == TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine &&
                    currentLine == numberOfLines - 1 &&
                    numberOfLines != 1) {
                    // Reset last line width for TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine
                    currentLineAdditionWidth = 0;
                }
                
                break;
        }
        
        // Current line
        [eachLineTagIndexs[currentLine] enumerateObjectsUsingBlock:^(NSNumber * _Nonnull tagIndexNumber, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger tagIndex = tagIndexNumber.unsignedIntegerValue;
            
            UIView *tagView = [self.dataSource tagCollectionView:self tagViewForIndex:tagIndex];
            CGSize tagSize = [self.delegate tagCollectionView:self sizeForTagAtIndex:tagIndex];
            
            CGPoint origin;
            origin.x = currentLineXOffset + currentLineX;
            origin.y = currentYBase + (currentLineMaxHeight - tagSize.height) / 2;
            
            tagSize.width += currentLineAdditionWidth;
            if (self.scrollDirection == TTGTagCollectionScrollDirectionVertical && tagSize.width > maxLineWidth) {
                tagSize.width = maxLineWidth;
            }
            
            tagView.hidden = NO;
            tagView.frame = (CGRect){origin, tagSize};
            
            currentLineX += tagSize.width + acturalHorizontalSpacing;
        }];
        
        // Next line
        currentYBase += currentLineMaxHeight + _verticalSpacing;
    }
    
    // Content size
    maxLineWidth += _contentInset.right + _contentInset.left;
    CGSize contentSize = CGSizeMake(maxLineWidth, currentYBase - _verticalSpacing + _contentInset.bottom);
    if (!CGSizeEqualToSize(contentSize, _scrollView.contentSize)) {
        _scrollView.contentSize = contentSize;
        _containerView.frame = (CGRect){CGPointZero, contentSize};
        
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

- (UIScrollView *)scrollView {
    return _scrollView;
}

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

- (NSUInteger)actualNumberOfLines {
    if (_scrollDirection == TTGTagCollectionScrollDirectionHorizontal) {
        return _numberOfLines;
    } else {
        return _actualNumberOfLines;
    }
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

- (CGSize)contentSize {
    [self layoutTagViews];
    return _scrollView.contentSize;
}

- (void)setManualCalculateHeight:(BOOL)manualCalculateHeight {
    _manualCalculateHeight = manualCalculateHeight;
    [self setNeedsLayoutTagViews];
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
    _preferredMaxLayoutWidth = preferredMaxLayoutWidth;
    [self setNeedsLayoutTagViews];
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator {
    _scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}

- (BOOL)showsHorizontalScrollIndicator {
    return _scrollView.showsHorizontalScrollIndicator;
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator {
    _scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
}

- (BOOL)showsVerticalScrollIndicator {
    return _scrollView.showsVerticalScrollIndicator;
}

@end
