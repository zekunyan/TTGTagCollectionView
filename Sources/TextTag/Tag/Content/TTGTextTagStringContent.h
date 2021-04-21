//
//  TTGTextTagStringContent.h
//  TTGTagCollectionView
//
//  Created by zekunyan on 2019/5/24.
//  Copyright (c) 2021 zekunyan. All rights reserved.
//

#if SWIFT_PACKAGE
#import "TTGTextTagContent.h"
#else
#import <TTGTagCollectionView/TTGTextTagContent.h>
#endif

/**
 Normal text content with custom font and color.
 */
@interface TTGTextTagStringContent : TTGTextTagContent

/// Text
@property (nonatomic, copy) NSString * _Nonnull text;
/// Text font
@property (nonatomic, copy) UIFont * _Nonnull textFont;
/// Text color
@property (nonatomic, copy) UIColor * _Nonnull textColor;

/// Init
- (instancetype _Nonnull)initWithText:(NSString *_Nonnull)text;
- (instancetype _Nonnull)initWithText:(NSString *_Nonnull)text
                             textFont:(UIFont *_Nullable)textFont
                            textColor:(UIColor *_Nullable)textColor;

/// Content
+ (instancetype _Nonnull)contentWithText:(NSString *_Nonnull)text;
+ (instancetype _Nonnull)contentWithText:(NSString *_Nonnull)text
                                textFont:(UIFont *_Nullable)textFont
                               textColor:(UIColor *_Nullable)textColor;

/// Base system methods
- (id _Nonnull)copyWithZone:(NSZone *_Nullable)zone;
- (NSString *_Nonnull)description;

@end
