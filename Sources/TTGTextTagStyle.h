//
//  TTGTextTagStyle.h
//  TTGTagCollectionView
//
//  Created by zekunyan on 2019/5/24.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TTGTextTagStyle : NSObject <NSCopying>

/// Background color
@property (nonatomic, copy) UIColor * _Nonnull backgroundColor; // Default is [UIColor lightGrayColor]

/// Text alignment
@property (nonatomic, assign) NSTextAlignment textAlignment; // Default is NSTextAlignmentCenter

/// Gradient background color
@property (nonatomic, assign) BOOL enableGradientBackground; // Default is NO
@property (nonatomic, copy) UIColor * _Nonnull gradientBackgroundStartColor;
@property (nonatomic, copy) UIColor * _Nonnull gradientBackgroundEndColor;
@property (nonatomic, assign) CGPoint gradientBackgroundStartPoint;
@property (nonatomic, assign) CGPoint gradientBackgroundEndPoint;

/// Corner radius
@property (nonatomic, assign) CGFloat cornerRadius; // Default is 4
@property (nonatomic, assign) Boolean cornerTopRight;
@property (nonatomic, assign) Boolean cornerTopLeft;
@property (nonatomic, assign) Boolean cornerBottomRight;
@property (nonatomic, assign) Boolean cornerBottomLeft;

/// Border
@property (nonatomic, assign) CGFloat borderWidth; // Default is [UIColor whiteColor]
@property (nonatomic, copy) UIColor * _Nonnull borderColor; // Default is 1

/// Shadow.
@property (nonatomic, copy) UIColor * _Nonnull shadowColor;    // Default is [UIColor blackColor]
@property (nonatomic, assign) CGSize shadowOffset;   // Default is (2, 2)
@property (nonatomic, assign) CGFloat shadowRadius;  // Default is 2f
@property (nonatomic, assign) CGFloat shadowOpacity; // Default is 0.3f

/// Extra space in width and height, will expand each tag's size
@property (nonatomic, assign) CGSize extraSpace;

/// Max width for a text tag. 0 and below means no max width.
@property (nonatomic, assign) CGFloat maxWidth;
/// Min width for a text tag. 0 and below means no min width.
@property (nonatomic, assign) CGFloat minWidth;

/// Max height for a text tag. 0 and below means no max height.
@property (nonatomic, assign) CGFloat maxHeight;
/// Min height for a text tag. 0 and below means no min height.
@property (nonatomic, assign) CGFloat minHeight;

/// Exact width. 0 and below means no work
@property (nonatomic, assign) CGFloat exactWidth;
/// Exact height. 0 and below means no work
@property (nonatomic, assign) CGFloat exactHeight;

/// Copy
- (id _Nonnull)copyWithZone:(NSZone *_Nullable)zone;

@end
