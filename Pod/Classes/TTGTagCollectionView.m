//
//  TTGTagCollectionView.m
//  Pods
//
//  Created by zorro on 15/12/26.
//
//

#import "TTGTagCollectionView.h"
#import "TTGTagCollectionLayout.h"
#import "TTGTagCollectionCell.h"
#import "TTGTagCollectionUtil.h"

static NSString *const TTGTagCollectionCellIdentifier = @"TTGTagCollectionCell";

@interface TTGTagCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) TTGTagCollectionLayout *layout;
@property (assign, nonatomic) CGFloat contentHeight;
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

#pragma mark - Public methods

- (void)reload {
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_dataSource numberOfTagsInTagCollectionView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TTGTagCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TTGTagCollectionCellIdentifier forIndexPath:indexPath];
    [cell setTagView:[_dataSource tagCollectionView:self tagViewForIndex:(NSUInteger) indexPath.row]];
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

    if (size.width > CGRectGetWidth(self.frame)) {
        size.width = CGRectGetWidth(self.frame);

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
    
    // Property
    _horizontalSpacing = 4;
    _verticalSpacing = 4;

    // Init layout
    TTGTagCollectionLayout *layout = [TTGTagCollectionLayout new];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = _horizontalSpacing;
    layout.minimumLineSpacing = _verticalSpacing;

    // Init collection view
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;

    // Add constraint
    [self addConstraints:[TTGTagCollectionUtil edgeConstraintsWithView1:collectionView view2:self]];

    // Register cell
    [collectionView registerClass:[TTGTagCollectionCell class] forCellWithReuseIdentifier:TTGTagCollectionCellIdentifier];

    _layout = layout;
    _collectionView = collectionView;
    
    [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc {
    [_collectionView removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark - Setter Getter

- (void)setHorizontalSpacing:(CGFloat)horizontalSpacing {
    _horizontalSpacing = horizontalSpacing;
    _layout.minimumInteritemSpacing = horizontalSpacing;
    [_collectionView reloadData];
}

- (void)setVerticalSpacing:(CGFloat)verticalSpacing {
    _verticalSpacing = verticalSpacing;
    _layout.minimumLineSpacing = verticalSpacing;
    [_collectionView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize contentSize = ((NSValue *)change[NSKeyValueChangeNewKey]).CGSizeValue;
        
        // Update height
        _contentHeight = contentSize.height;
        
        // Call back
        if ([_delegate respondsToSelector:@selector(tagCollectionView:updateContentHeight:)]) {
            [_delegate tagCollectionView:self updateContentHeight:contentSize.height];
        }
    }
}

@end
