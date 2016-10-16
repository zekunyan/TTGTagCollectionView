//
// Created by zorro on 15/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTGTagCollectionView.h"

@class TTGTextTagCollectionView;

@protocol TTGTextTagCollectionViewDelegate <NSObject>
@optional
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize;
@end

@interface TTGTextTagCollectionView : UIView
@property (weak, nonatomic) id <TTGTextTagCollectionViewDelegate> delegate;
@property (assign, nonatomic) BOOL enableTagSelection;

// Text
@property (strong, nonatomic) UIFont *tagTextFont;
@property (strong, nonatomic) UIColor *tagTextColor;
@property (strong, nonatomic) UIColor *tagSelectedTextColor;

// Extra space
@property (assign, nonatomic) CGSize extraSpace;

// Background color
@property (strong, nonatomic) UIColor *tagBackgroundColor;
@property (strong, nonatomic) UIColor *tagSelectedBackgroundColor;

// Corner radius
@property (assign, nonatomic) CGFloat tagCornerRadius;
@property (assign, nonatomic) CGFloat tagSelectedCornerRadius;

// Border
@property (assign, nonatomic) CGFloat tagBorderWidth;
@property (assign, nonatomic) CGFloat tagSelectedBorderWidth;
@property (strong, nonatomic) UIColor *tagBorderColor;
@property (strong, nonatomic) UIColor *tagSelectedBorderColor;

// Space
@property (assign, nonatomic) CGFloat horizontalSpacing;
@property (assign, nonatomic) CGFloat verticalSpacing;

// Content size
@property (nonatomic, assign, readonly) CGSize contentSize;

// Scroll direction. Default is vertical
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

// Number of lines for horizontal direction
@property (nonatomic, assign) NSUInteger numberOfLinesForHorizontalScrollDirection;

- (void)reload;

- (void)addTag:(NSString *)tag;

- (void)addTags:(NSArray <NSString *> *)tags;

- (void)removeTag:(NSString *)tag;

- (void)removeTagAtIndex:(NSUInteger)index;

- (void)removeAllTags;

- (void)setTagAtIndex:(NSUInteger)index selected:(BOOL)selected;

- (NSArray <NSString *> *)allTags;

- (NSArray <NSString *> *)allSelectedTags;

- (NSArray <NSString *> *)allNotSelectedTags;

@end