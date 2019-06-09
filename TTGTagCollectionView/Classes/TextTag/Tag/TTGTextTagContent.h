//
//  TTGTextTagContent.h
//  TTGTagCollectionView
//
//  Created by tutuge on 2019/5/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTGTextTagContent : NSObject <NSCopying>

- (NSAttributedString *)getContentAttributedString;

- (id)copyWithZone:(nullable NSZone *)zone;

@end

NS_ASSUME_NONNULL_END
