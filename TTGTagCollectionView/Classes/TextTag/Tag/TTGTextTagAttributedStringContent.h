//
//  TTGTextTagAttributedStringContent.h
//  TTGTagCollectionView
//
//  Created by tutuge on 2019/5/24.
//

#import "TTGTextTagContent.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTGTextTagAttributedStringContent : TTGTextTagContent

// Attributed text
@property (nonatomic, copy) NSAttributedString *attributedText;

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText;

+ (instancetype)contentWithAttributedText:(NSAttributedString *)attributedText;

- (id)copyWithZone:(nullable NSZone *)zone;

- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
