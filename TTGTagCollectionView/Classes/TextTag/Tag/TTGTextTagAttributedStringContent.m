//
//  TTGTextTagAttributedStringContent.m
//  TTGTagCollectionView
//
//  Created by tutuge on 2019/5/24.
//

#import "TTGTextTagAttributedStringContent.h"

@implementation TTGTextTagAttributedStringContent

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText {
    self = [super init];
    if (self) {
        self.attributedText = attributedText;
    }
    return self;
}

+ (instancetype)contentWithAttributedText:(NSAttributedString *)attributedText {
    return [[self alloc] initWithAttributedText:attributedText];
}

- (NSAttributedString *)getContentAttributedString {
    return _attributedText ?: [NSAttributedString new];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    TTGTextTagAttributedStringContent *copy = (TTGTextTagAttributedStringContent *)[super copyWithZone:zone];
    if (copy != nil) {
        copy.attributedText = self.attributedText;
    }
    return copy;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.attributedText=%@", self.attributedText];
    [description appendString:@">"];
    return description;
}

@end
