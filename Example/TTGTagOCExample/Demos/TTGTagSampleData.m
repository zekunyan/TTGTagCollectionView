//
//  TTGTagSampleData.m
//

#import "TTGTagSampleData.h"

@implementation TTGTagSampleData

+ (NSArray<NSString *> *)autoLayoutLongParagraphWords {
    static NSArray<NSString *> *words = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        words = @[
            @"AutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayoutAutoLayout",
            @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
            @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
            @"on", @"constraints", @"placed", @"on", @"those", @"views",
            @"For", @"example", @"you", @"can", @"constrain", @"a", @"button",
            @"so", @"that", @"it", @"is", @"horizontally", @"centered", @"with",
            @"an", @"Image", @"view", @"and", @"so", @"that", @"the", @"button's",
            @"top", @"edge", @"always", @"remains", @"8", @"points", @"below", @"the",
            @"image's", @"bottom", @"If", @"the", @"image", @"view's", @"size", @"or",
            @"position", @"changes", @"the", @"button's", @"position", @"automatically", @"adjusts", @"to", @"match"
        ];
    });
    return words;
}

+ (NSArray<NSString *> *)shortSampleWords {
    static NSArray<NSString *> *words = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        words = @[
            @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
            @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
            @"on", @"constraints", @"placed", @"on", @"those", @"views"
        ];
    });
    return words;
}

+ (NSArray<NSString *> *)shortWordsRepeated:(NSUInteger)repeatCount {
    NSArray<NSString *> *base = [self shortSampleWords];
    if (repeatCount == 0) return @[];
    NSMutableArray *out = [NSMutableArray arrayWithCapacity:base.count * repeatCount];
    for (NSUInteger i = 0; i < repeatCount; i++) {
        [out addObjectsFromArray:base];
    }
    return out;
}

@end
