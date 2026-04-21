//
//  TTGTagSampleData.h
//  TTGTagCollectionView_Example
//
//  Shared placeholder strings for demos (avoid duplicating large literals).

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTGTagSampleData : NSObject

/// Long Auto Layout paragraph split into words; for two-column and large-list demos.
+ (NSArray<NSString *> *)autoLayoutLongParagraphWords;

/// Short list (~22 words) reused by most demos.
+ (NSArray<NSString *> *)shortSampleWords;

/// Repeats `shortSampleWords` N times to build a long array (e.g. many tags).
+ (NSArray<NSString *> *)shortWordsRepeated:(NSUInteger)repeatCount;

@end

NS_ASSUME_NONNULL_END
