//
//  TTGTagCollectionLayout.m
//  Pods
//
//  Created by tutuge on 2016/10/16.
//
//

#import "TTGTagCollectionLayout.h"

@interface TTGTagCollectionLayout ()
@property (nonatomic, strong) NSMutableArray *totalAttributes;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;
@end

@implementation TTGTagCollectionLayout

- (void)prepareLayout {
    [super prepareLayout];

    if (_scrollDirection == TTGTagCollectionScrollDirectionVertical) {
        [self prepareForScrollVertical];
    } else if (_scrollDirection == TTGTagCollectionScrollDirectionHorizontal) {
        [self prepareForScrollHorizontal];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *currentIncludeAttributes = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *attributes in _totalAttributes) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [currentIncludeAttributes addObject:attributes];
        }
    }
    return currentIncludeAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    id <UICollectionViewDelegateFlowLayout> delegate = (id <UICollectionViewDelegateFlowLayout>) self.collectionView.delegate;
    CGSize itemSize = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    attributes.size = itemSize;
    attributes.frame = CGRectMake(0, 0, itemSize.width, itemSize.height);
    return attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(_contentWidth, _contentHeight);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

#pragma mark - Private methods

- (void)prepareForScrollVertical {
    CGFloat currentX = 0, currentYBase = -_verticalSpacing, tmpHeight = 0;
    CGRect frame;
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];

    CGFloat visibleWidth = CGRectGetWidth(self.collectionView.frame);
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    _totalAttributes = [[NSMutableArray alloc] initWithCapacity:(NSUInteger) count];

    // Create attributes, set X and Get each line max height
    for (NSInteger i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [_totalAttributes addObject:attributes];

        frame = attributes.frame;

        if (currentX + CGRectGetWidth(frame) + _horizontalSpacing > visibleWidth) {
            // New Line
            [eachLineMaxHeightNumbers addObject:@(tmpHeight)];
            tmpHeight = 0;
            currentX = 0;
        }

        frame.origin.x = currentX;
        attributes.frame = frame;

        currentX += CGRectGetWidth(frame) + _horizontalSpacing;
        tmpHeight = CGRectGetHeight(frame) > tmpHeight ? CGRectGetHeight(frame) : tmpHeight;
    }

    // Add last
    [eachLineMaxHeightNumbers addObject:@(tmpHeight)];

    NSUInteger currentLineIndex = 0;
    CGFloat currentLineMaxHeight = 0;

    // Set Y
    for (UICollectionViewLayoutAttributes *attributes in _totalAttributes) {
        frame = attributes.frame;

        if (frame.origin.x == 0 && currentLineIndex < eachLineMaxHeightNumbers.count) {
            currentYBase += currentLineMaxHeight + _verticalSpacing;
            currentLineMaxHeight = eachLineMaxHeightNumbers[currentLineIndex].floatValue;
            currentLineIndex += 1;
        }

        frame.origin.y = currentYBase + (currentLineMaxHeight - CGRectGetHeight(frame)) / 2;
        attributes.frame = frame;
    }

    _contentWidth = visibleWidth;
    _contentHeight = currentYBase + currentLineMaxHeight;
}

- (void)prepareForScrollHorizontal {
    CGFloat totalWidthInOneLine = 0, averageWidthEachLine = 0, currentX = 0, currentYBase = -_verticalSpacing, tmpHeight = 0;
    CGRect frame;

    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    _totalAttributes = [[NSMutableArray alloc] initWithCapacity:(NSUInteger) count];
    _numberOfLines = _numberOfLines == 0 ? 1 : _numberOfLines;

    // Create attributes
    for (NSInteger i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [_totalAttributes addObject:attributes];
        totalWidthInOneLine += CGRectGetWidth(attributes.frame) + _horizontalSpacing;
    }

    // Calculate each line width
    averageWidthEachLine = totalWidthInOneLine / (CGFloat)_numberOfLines;

    // Set X and Get each line max height
    for (UICollectionViewLayoutAttributes *attributes in _totalAttributes) {
        frame = attributes.frame;
        frame.origin.x = currentX;
        attributes.frame = frame;

        currentX += CGRectGetWidth(frame) + _horizontalSpacing;
        _contentWidth = currentX > _contentWidth ? currentX : _contentWidth;
        tmpHeight = CGRectGetHeight(frame) > tmpHeight ? CGRectGetHeight(frame) : tmpHeight;

        if (currentX > averageWidthEachLine && eachLineMaxHeightNumbers.count < _numberOfLines) {
            [eachLineMaxHeightNumbers addObject:@(tmpHeight)];
            tmpHeight = 0;
            currentX = 0;
        }
    }

    // Add last
    [eachLineMaxHeightNumbers addObject:@(tmpHeight)];

    // Set Y
    NSUInteger currentLineIndex = 0;
    CGFloat currentLineMaxHeight = 0;
    for (UICollectionViewLayoutAttributes *attributes in _totalAttributes) {
        frame = attributes.frame;

        if (frame.origin.x == 0 && currentLineIndex < eachLineMaxHeightNumbers.count) {
            currentYBase += currentLineMaxHeight + _verticalSpacing;
            currentLineMaxHeight = eachLineMaxHeightNumbers[currentLineIndex].floatValue;
            currentLineIndex += 1;
        }

        frame.origin.y = currentYBase + (currentLineMaxHeight - CGRectGetHeight(frame)) / 2;
        attributes.frame = frame;
    }

    _contentHeight = currentYBase + currentLineMaxHeight;
}

#pragma mark - Setter

- (void)setScrollDirection:(TTGTagCollectionScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    [self invalidateLayout];
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    [self invalidateLayout];
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing {
    _verticalSpacing = verticalSpacing;
    [self invalidateLayout];
}

- (void)setHorizontalSpacing:(CGFloat)horizontalSpacing {
    _horizontalSpacing = horizontalSpacing;
    [self invalidateLayout];
}

@end
