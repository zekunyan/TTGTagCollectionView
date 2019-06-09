//
//  TTGTextTagStyle.h
//  TTGTagCollectionView
//
//  Created by tutuge on 2019/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTGTextTagStyle : NSObject <NSCopying>

// Background color
@property (nonatomic, strong) UIColor *backgroundColor;

// Gradient background color
@property (nonatomic, assign) BOOL enableGradientBackground;
@property (nonatomic, strong) UIColor *gradientBackgroundStartColor;
@property (nonatomic, strong) UIColor *gradientBackgroundEndColor;
@property (nonatomic, assign) CGPoint gradientBackgroundStartPoint;
@property (nonatomic, assign) CGPoint gradientBackgroundEndPoint;

// Corner radius
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) Boolean cornerTopRight;
@property (nonatomic, assign) Boolean cornerTopLeft;
@property (nonatomic, assign) Boolean cornerBottomRight;
@property (nonatomic, assign) Boolean cornerBottomLeft;

// Border
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;

// Shadow.
@property (nonatomic, copy) UIColor *shadowColor;    // Default is [UIColor black]
@property (nonatomic, assign) CGSize shadowOffset;   // Default is (2, 2)
@property (nonatomic, assign) CGFloat shadowRadius;  // Default is 2f
@property (nonatomic, assign) CGFloat shadowOpacity; // Default is 0.3f

// Extra space in width and height, will expand each tag's size
@property (nonatomic, assign) CGSize extraSpace;

// Max width for a text tag. 0 and below means no max width.
@property (nonatomic, assign) CGFloat maxWidth;
// Min width for a text tag. 0 and below means no min width.
@property (nonatomic, assign) CGFloat minWidth;

// Max height for a text tag. 0 and below means no max height.
@property (nonatomic, assign) CGFloat maxHeight;
// Min height for a text tag. 0 and below means no min height.
@property (nonatomic, assign) CGFloat minHeight;

// Exact width. 0 and below means no work
@property (nonatomic, assign) CGFloat exactWidth;
// Exact height. 0 and below means no work
@property (nonatomic, assign) CGFloat exactHeight;

- (id)copyWithZone:(nullable NSZone *)zone;

@end

NS_ASSUME_NONNULL_END
