//
//  TTGTagCollectionView.m
//  Pods
//
//  Created by zorro on 15/12/26.
//
//

#import "TTGTagCollectionView.h"
#import "TTGTagCollectionCell.h"
#import "TTGTagCollectionLayout.h"

static NSString *const TTGTagCollectionCellIdentifier = @"TTGTagCollectionCell";

@interface TTGTagCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) TTGTagCollectionLayout *layout;
@end

@implementation TTGTagCollectionView

#pragma mark - Dealloc

- (void)dealloc {
    [_collectionView removeObserver:self forKeyPath:@"contentSize"];
}

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

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize {
    return _layout.collectionViewContentSize;
}

#pragma mark - Public methods

- (void)reload {
    [_collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource numberOfTagsInTagCollectionView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTGTagCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TTGTagCollectionCellIdentifier forIndexPath:indexPath];
    [cell setTagView:[_dataSource tagCollectionView:self tagViewForIndex:(NSUInteger) indexPath.row]];

    cell.layer.shadowColor = _shadowColor.CGColor;
    cell.layer.shadowOffset = _shadowOffset;
    cell.layer.shadowRadius = _shadowRadius;
    cell.layer.shadowOpacity = _shadowOpacity;
    cell.layer.masksToBounds = NO;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(tagCollectionView:didSelectTag:atIndex:)]) {
        [_delegate tagCollectionView:self didSelectTag:[_dataSource tagCollectionView:self tagViewForIndex:(NSUInteger) indexPath.row] atIndex:(NSUInteger) indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [_delegate tagCollectionView:self sizeForTagAtIndex:(NSUInteger) indexPath.row];

    if (size.width > CGRectGetWidth(self.frame) - self.contentInset.left - self.contentInset.right) {
        size.width = CGRectGetWidth(self.frame) - self.contentInset.left - self.contentInset.right;

        // Update tag view width
        UIView *tagView = [_dataSource tagCollectionView:self tagViewForIndex:(NSUInteger) indexPath.row];
        CGRect frame = tagView.frame;
        frame.size = size;
        tagView.frame = frame;
    }

    return size;
}

#pragma mark - Private methods

- (void)commonInit {
    if (_collectionView) {
        return;
    }
    
    // Shadow
    _shadowColor = [UIColor blackColor];
    _shadowOffset = CGSizeZero;
    _shadowRadius = 0.0f;
    _shadowOpacity = 0.5f;

    // Layout
    _layout = [TTGTagCollectionLayout new];
    _layout.scrollDirection = TTGTagCollectionScrollDirectionVertical;
    _layout.horizontalSpacing = 4;
    _layout.verticalSpacing = 4;
    _layout.contentInset = UIEdgeInsetsMake(2, 2, 2, 2);

    // Init collection view
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    [self addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];

    // Register cell
    [_collectionView registerClass:[TTGTagCollectionCell class] forCellWithReuseIdentifier:TTGTagCollectionCellIdentifier];

    // Add KVO
    [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - Setter Getter

- (CGSize)contentSize {
    return _layout.collectionViewContentSize;
}

- (CGFloat)horizontalSpacing {
    return _layout.horizontalSpacing;
}

- (void)setHorizontalSpacing:(CGFloat)horizontalSpacing {
    _layout.horizontalSpacing = horizontalSpacing;
    [self reload];
}

- (CGFloat)verticalSpacing {
    return _layout.verticalSpacing;
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing {
    _layout.verticalSpacing = verticalSpacing;
    [self reload];
}

- (TTGTagCollectionScrollDirection)scrollDirection {
    return _layout.scrollDirection;
}

- (void)setScrollDirection:(TTGTagCollectionScrollDirection)scrollDirection {
    _layout.scrollDirection = scrollDirection;
    [self reload];
}

- (NSUInteger)numberOfLines {
    return _layout.numberOfLines;
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    numberOfLines = numberOfLines == 0 ? 1 : numberOfLines;
    _layout.numberOfLines = numberOfLines;
    [self reload];
}

- (UIEdgeInsets)contentInset {
    return _layout.contentInset;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _layout.contentInset = contentInset;
}

- (TTGTagCollectionAlignment)alignment {
    return _layout.alignment;
}

- (void)setAlignment:(TTGTagCollectionAlignment)alignment {
    _layout.alignment = alignment;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize contentSize = ((NSValue *) change[NSKeyValueChangeNewKey]).CGSizeValue;

        // Call back
        if ([_delegate respondsToSelector:@selector(tagCollectionView:updateContentSize:)]) {
            [_delegate tagCollectionView:self updateContentSize:contentSize];
        }
    }
}

@end
