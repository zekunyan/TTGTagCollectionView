//
//  TTGTextTagStringContent.h
//  TTGTagCollectionView
//
//  Created by tutuge on 2019/5/24.
//

#import "TTGTextTagContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGTextTagStringContent : TTGTextTagContent

// Text
@property (nonatomic, copy) NSString *text;
// Text font
@property (nonatomic, copy) UIFont *textFont;
// Text color
@property (nonatomic, copy) UIColor *textColor;

// Init

- (instancetype)initWithText:(NSString *)text;

- (instancetype)initWithText:(NSString *)text
                    textFont:(UIFont *)textFont
                   textColor:(UIColor *)textColor;

+ (instancetype)contentWithText:(NSString *)text;

+ (instancetype)contentWithText:(NSString *)text
                       textFont:(UIFont *)textFont
                      textColor:(UIColor *)textColor;

// Copy
- (id)copyWithZone:(nullable NSZone *)zone;

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
