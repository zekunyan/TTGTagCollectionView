//
//  TTGDemoAttributedTagExamples.h
//  Builds TTGTextTag instances with attributed content for TTGDemoAttributedStringTagsViewController.

#import <Foundation/Foundation.h>

@class TTGTextTag;

NS_ASSUME_NONNULL_BEGIN

@interface TTGDemoAttributedTagExamples : NSObject

/// Demonstration tags: mixed fonts, strikethrough, attachments, etc.
+ (NSArray<TTGTextTag *> *)allDemonstrationTags;

@end

NS_ASSUME_NONNULL_END
