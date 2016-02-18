//
//  TTGTagCollectionView.h
//  Pods
//
//  Created by zorro on 15/12/26.
//
//

#import <UIKit/UIKit.h>

@class TTGTagCollectionView;

@protocol TTGTagCollectionViewDelegate <NSObject>
@required
- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index;

@optional
- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;

- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView updateContentHeight:(CGFloat)newContentHeight;
@end

@protocol TTGTagCollectionViewDataSource <NSObject>
@required
- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView;

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index;
@end

@interface TTGTagCollectionView : UIView
@property (weak, nonatomic) id <TTGTagCollectionViewDataSource> dataSource;
@property (weak, nonatomic) id <TTGTagCollectionViewDelegate> delegate;

// Space
@property (assign, nonatomic) CGFloat horizontalSpacing;
@property (assign, nonatomic) CGFloat verticalSpacing;

// Content height
@property (assign, nonatomic, readonly) CGFloat contentHeight;

- (void)reload;
@end
