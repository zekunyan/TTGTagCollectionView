//
//  TTGTextTagItem.h
//  Masonry
//
//  Created by tutuge on 2018/5/16.
//

#import <Foundation/Foundation.h>

@class TTGTextTagTitleWrapper;
@class TTGTextTagStyle;
@class TTGTextTagAttachment;

@interface TTGTextTagItem : NSObject

// Content
@property (nonatomic, strong) TTGTextTagTitleWrapper *title;
@property (nonatomic, strong) TTGTextTagStyle *style;
@property (nonatomic, strong) NSMutableArray <TTGTextTagAttachment *> *attachments;

// Extra data. You can use this to bind any object you want to each tag.
@property (nonatomic, strong) NSObject *extraData;

// Gesture
@property (nonatomic, assign) BOOL enableTapGesture;
@property (nonatomic, assign) BOOL enableLongTapGesture;
// Gesture callback
@property (nonatomic, copy) void (^onTap)(TTGTextTagItem *item);
@property (nonatomic, copy) void (^onLongTap)(TTGTextTagItem *item);

// Update content and style
- (void)update;

@end

@interface TTGTextTagTitleWrapper : NSObject
/* Normal String */
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
/* Attributed String */
@property (nonatomic, strong) NSAttributedString *attributedString;
@end

@interface TTGTextTagStyle : NSObject
// Background color
@property (strong, nonatomic) UIColor *backgroundColor;

// Gradient background color
@property (assign, nonatomic) BOOL shouldUseGradientBackground;
@property (strong, nonatomic) UIColor *gradientBackgroundStartColor;
@property (strong, nonatomic) UIColor *gradientBackgroundEndColor;
@property (assign, nonatomic) CGPoint gradientStartPoint;
@property (assign, nonatomic) CGPoint gradientEndPoint;

// Corner radius
@property (assign, nonatomic) CGFloat cornerRadius;

// Border
@property (assign, nonatomic) CGFloat borderWidth;
@property (strong, nonatomic) UIColor *borderColor;

// Shadow
@property (nonatomic, copy) UIColor *shadowColor;    // Default is [UIColor black]
@property (nonatomic, assign) CGSize shadowOffset;   // Default is (2, 2)
@property (nonatomic, assign) CGFloat shadowRadius;  // Default is 2f
@property (nonatomic, assign) CGFloat shadowOpacity; // Default is 0.3f

// Tag extra space in width and height, will expand each tag's size
@property (assign, nonatomic) CGSize extraSpace;
// Tag max width for a text tag. 0 and below means no max width.
@property (assign, nonatomic) CGFloat maxWidth;
// Tag min width for a text tag. 0 and below means no min width.
@property (assign, nonatomic) CGFloat minWidth;
@end

typedef NS_ENUM(NSInteger, TTGTextTagAttachmentPosition) {
    TTGTextTagAttachmentPositionBackground = 1,
    TTGTextTagAttachmentPositionLeft,
    TTGTextTagAttachmentPositionRight,
    TTGTextTagAttachmentPositionTop,
    TTGTextTagAttachmentPositionBottom
};

@interface TTGTextTagAttachment : NSObject
// Position
@property (nonatomic, assign) TTGTextTagAttachmentPosition position;
// View
@property (nonatomic, strong) UIView *view;
// Attachment size, default is (0. 0)
@property (nonatomic, assign) CGSize size;
// Attachment center offset, default is (0, 0)
@property (nonatomic, assign) CGPoint centerOffset;
// Attachment rect update callback，you can change the final rect for attachment view
@property (nonatomic, copy) CGRect (^rectForBounds)(CGRect bounds);
@end
