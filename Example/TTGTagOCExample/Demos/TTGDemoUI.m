//
//  TTGDemoUI.m
//

#import "TTGDemoUI.h"

@implementation TTGDemoUI

+ (void)applyScreenBackground:(UIView *)view {
    view.backgroundColor = UIColor.systemBackgroundColor;
}

+ (UILabel *)titleLabel:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    label.textColor = UIColor.labelColor;
    label.numberOfLines = 0;
    return label;
}

+ (UILabel *)descriptionLabel:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    label.textColor = UIColor.secondaryLabelColor;
    label.numberOfLines = 0;
    return label;
}

+ (UILabel *)sectionLabel:(NSString *)text {
    UILabel *label = [UILabel new];
    label.text = text;
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    label.textColor = UIColor.secondaryLabelColor;
    label.numberOfLines = 1;
    return label;
}

+ (void)styleTagSurface:(UIView *)view {
    view.backgroundColor = UIColor.systemGray6Color;
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
}

+ (void)styleLogLabel:(UILabel *)label {
    label.text = @"Tap a tag to inspect the callback.";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColor.secondaryLabelColor;
    label.numberOfLines = 0;
    label.adjustsFontSizeToFitWidth = NO;
}

+ (void)styleLogTextView:(UITextView *)textView {
    textView.backgroundColor = UIColor.systemGray6Color;
    textView.layer.cornerRadius = 10;
    textView.textColor = UIColor.secondaryLabelColor;
    textView.font = [UIFont monospacedSystemFontOfSize:12 weight:UIFontWeightRegular];
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.editable = NO;
}

+ (void)stylePrimaryButton:(UIButton *)button {
    UIButtonConfiguration *configuration = [UIButtonConfiguration plainButtonConfiguration];
    NSString *title = [button titleForState:UIControlStateNormal];
    if (title.length > 0) {
        NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold] };
        configuration.attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    }
    configuration.baseForegroundColor = UIColor.systemBlueColor;
    configuration.background.backgroundColor = UIColor.systemGray6Color;
    configuration.background.cornerRadius = 10;
    configuration.contentInsets = NSDirectionalEdgeInsetsMake(10, 12, 10, 12);
    button.configuration = configuration;
}

+ (TTGTextTagStringContent *)contentWithText:(NSString *)text {
    TTGTextTagStringContent *content = [TTGTextTagStringContent contentWithText:text];
    content.textFont = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    content.textColor = UIColor.whiteColor;
    return content;
}

+ (TTGTextTag *)tagWithText:(NSString *)text {
    TTGTextTag *tag = [TTGTextTag tagWithContent:[self contentWithText:text]
                                           style:[self primaryTagStyle]];
    tag.selectedStyle = [self selectedTagStyleWithColor:UIColor.systemIndigoColor];
    return tag;
}

+ (TTGTextTagStyle *)primaryTagStyle {
    TTGTextTagStyle *style = [TTGTextTagStyle new];
    style.backgroundColor = UIColor.systemBlueColor;
    style.cornerRadius = 14;
    style.extraSpace = CGSizeMake(12, 6);
    style.borderWidth = 0;
    style.shadowOpacity = 0;
    return style;
}

+ (TTGTextTagStyle *)selectedTagStyleWithColor:(UIColor *)color {
    TTGTextTagStyle *style = [self primaryTagStyle];
    style.backgroundColor = color;
    return style;
}

@end
