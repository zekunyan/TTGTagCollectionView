//
//  TTGDemoUI.h
//

#import <UIKit/UIKit.h>
#import <TTGTags/TTGTags-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTGDemoUI : NSObject

+ (void)applyScreenBackground:(UIView *)view;
+ (UILabel *)titleLabel:(NSString *)text;
+ (UILabel *)descriptionLabel:(NSString *)text;
+ (UILabel *)sectionLabel:(NSString *)text;
+ (void)styleTagSurface:(UIView *)view;
+ (void)styleLogLabel:(UILabel *)label;
+ (void)styleLogTextView:(UITextView *)textView;
+ (void)stylePrimaryButton:(UIButton *)button;

+ (TTGTextTagStringContent *)contentWithText:(NSString *)text;
+ (TTGTextTag *)tagWithText:(NSString *)text;
+ (TTGTextTagStyle *)primaryTagStyle;
+ (TTGTextTagStyle *)selectedTagStyleWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
