//
//  TTGDemoAttributedTagExamples.m
//

#import "TTGDemoAttributedTagExamples.h"
#import <TTGTags/TTGTags-Swift.h>

@implementation TTGDemoAttributedTagExamples

+ (NSArray<TTGTextTag *> *)allDemonstrationTags {
    NSMutableArray<TTGTextTag *> *tags = [NSMutableArray array];
    [tags addObject:[self tagWithDefaultChromeAndContent:[self mixedFontAndColorString]]];
    [tags addObject:[self tagWithDefaultChromeAndContent:[self strikethroughAndUnderlineString]]];
    [tags addObject:[self tagWithDefaultChromeAndContent:[self kernSpacingString]]];
    [tags addObject:[self tagWithDefaultChromeAndContent:[self shadowTextString]]];
    [tags addObject:[self tagWithDefaultChromeAndContent:[self strokeTextString]]];
    [tags addObject:[self tagWithDefaultChromeAndContent:[self superscriptString]]];
    [tags addObject:[self tagWithDefaultChromeAndContent:[self imageAttachmentString]]];

    [tags addObject:[self badgeTagWithAttributedText:[self badgeAttributedString:@"NEW"]]];
    [tags addObject:[self badgeTagWithAttributedText:[self badgeAttributedString:@"HOT"]]];
    [tags addObject:[self badgeTagWithAttributedText:[self badgeAttributedString:@"PRO"]]];
    [tags addObject:[self badgeTagWithAttributedText:[self badgeAttributedString:@"FREE"]]];

    [tags addObject:[self selectableAttributedTag]];
    [tags addObject:[self tagWithDefaultChromeAndContent:[self paragraphStyleString]]];
    return tags;
}

#pragma mark - Attributed strings

+ (NSAttributedString *)mixedFontAndColorString {
    NSMutableAttributedString *result = [NSMutableAttributedString new];
    NSDictionary *boldBlue = @{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
        NSForegroundColorAttributeName: [UIColor systemBlueColor]
    };
    NSDictionary *italicRed = @{
        NSFontAttributeName: [UIFont italicSystemFontOfSize:14],
        NSForegroundColorAttributeName: [UIColor systemRedColor]
    };
    NSDictionary *monoGreen = @{
        NSFontAttributeName: [UIFont monospacedSystemFontOfSize:13 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName: [UIColor systemGreenColor]
    };
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Bold " attributes:boldBlue]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Italic " attributes:italicRed]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Mono" attributes:monoGreen]];
    return result;
}

+ (NSAttributedString *)strikethroughAndUnderlineString {
    NSMutableAttributedString *result = [NSMutableAttributedString new];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Strikethrough" attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName: [UIColor darkGrayColor],
        NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle),
        NSStrikethroughColorAttributeName: [UIColor systemRedColor]
    }]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@" + " attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName: [UIColor grayColor]
    }]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"Underline" attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName: [UIColor darkGrayColor],
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleDouble),
        NSUnderlineColorAttributeName: [UIColor systemBlueColor]
    }]];
    return result;
}

+ (NSAttributedString *)kernSpacingString {
    return [[NSAttributedString alloc] initWithString:@"W I D E   S P A C I N G" attributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:13],
        NSForegroundColorAttributeName: [UIColor systemIndigoColor],
        NSKernAttributeName: @(4.0)
    }];
}

+ (NSAttributedString *)shadowTextString {
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    shadow.shadowOffset = CGSizeMake(2, 2);
    shadow.shadowBlurRadius = 3;
    return [[NSAttributedString alloc] initWithString:@"Text Shadow" attributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
        NSForegroundColorAttributeName: [UIColor systemOrangeColor],
        NSShadowAttributeName: shadow
    }];
}

+ (NSAttributedString *)strokeTextString {
    return [[NSAttributedString alloc] initWithString:@"Stroke Text" attributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:22],
        NSForegroundColorAttributeName: [UIColor systemPurpleColor],
        NSStrokeColorAttributeName: [UIColor systemPurpleColor],
        NSStrokeWidthAttributeName: @(3.0)
    }];
}

+ (NSAttributedString *)superscriptString {
    NSMutableAttributedString *result = [NSMutableAttributedString new];
    NSDictionary *normalAttrs = @{
        NSFontAttributeName: [UIFont italicSystemFontOfSize:18],
        NSForegroundColorAttributeName: [UIColor labelColor]
    };
    NSDictionary *superAttrs = @{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
        NSForegroundColorAttributeName: [UIColor systemRedColor],
        NSBaselineOffsetAttributeName: @(8.0)
    };
    NSDictionary *subAttrs = @{
        NSFontAttributeName: [UIFont systemFontOfSize:12],
        NSForegroundColorAttributeName: [UIColor systemBlueColor],
        NSBaselineOffsetAttributeName: @(-4.0)
    };
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"E=mc" attributes:normalAttrs]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"2" attributes:superAttrs]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"  H" attributes:normalAttrs]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"2" attributes:subAttrs]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@"O" attributes:normalAttrs]];
    return result;
}

+ (NSAttributedString *)imageAttachmentString {
    NSMutableAttributedString *result = [NSMutableAttributedString new];
    NSDictionary *textAttrs = @{
        NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName: [UIColor systemPinkColor]
    };
    NSTextAttachment *attachment = [NSTextAttachment new];
    UIImageSymbolConfiguration *config =
        [UIImageSymbolConfiguration configurationWithPointSize:16 weight:UIImageSymbolWeightMedium];
    UIImage *heart = [UIImage systemImageNamed:@"heart.fill" withConfiguration:config];
    attachment.image = [heart imageWithTintColor:[UIColor systemPinkColor]
                                   renderingMode:UIImageRenderingModeAlwaysOriginal];

    [result appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    [result appendAttributedString:[[NSAttributedString alloc] initWithString:@" Favorite " attributes:textAttrs]];
    [result appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    return result;
}

+ (NSAttributedString *)badgeAttributedString:(NSString *)text {
    return [[NSAttributedString alloc] initWithString:text attributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:13],
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSKernAttributeName: @(1.5)
    }];
}

+ (NSAttributedString *)paragraphStyleString {
    NSMutableParagraphStyle *paraStyle = [NSMutableParagraphStyle new];
    paraStyle.lineSpacing = 6;
    paraStyle.alignment = NSTextAlignmentCenter;

    NSMutableAttributedString *result =
        [[NSMutableAttributedString alloc] initWithString:@"Paragraph Style\nwith line spacing"
                                               attributes:@{
                                                   NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
                                                   NSForegroundColorAttributeName: [UIColor secondaryLabelColor],
                                                   NSParagraphStyleAttributeName: paraStyle
                                               }];
    [result addAttributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
        NSForegroundColorAttributeName: [UIColor labelColor]
    } range:NSMakeRange(0, 15)];
    return result;
}

#pragma mark - TTGTextTag factories

+ (TTGTextTag *)tagWithDefaultChromeAndContent:(NSAttributedString *)attributedString {
    TTGTextTag *tag = [TTGTextTag new];
    tag.content = [TTGTextTagAttributedStringContent contentWithAttributedText:attributedString];

    TTGTextTagStyle *style = [TTGTextTagStyle new];
    style.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1.00];
    style.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.87 alpha:1.00];
    style.borderWidth = 1;
    style.cornerRadius = 8;
    style.extraSpace = CGSizeMake(10, 8);
    style.shadowColor = [UIColor colorWithWhite:0 alpha:0.08];
    style.shadowOffset = CGSizeMake(0, 1);
    style.shadowOpacity = 1;
    style.shadowRadius = 2;

    TTGTextTagStyle *selectedStyle = [style copy];
    selectedStyle.backgroundColor = [UIColor colorWithRed:0.90 green:0.93 blue:1.00 alpha:1.00];
    selectedStyle.borderColor = [UIColor systemBlueColor];
    selectedStyle.borderWidth = 1.5;

    tag.style = style;
    tag.selectedStyle = selectedStyle;
    return tag;
}

+ (TTGTextTag *)badgeTagWithAttributedText:(NSAttributedString *)attributedString {
    TTGTextTag *tag = [TTGTextTag new];
    tag.content = [TTGTextTagAttributedStringContent contentWithAttributedText:attributedString];

    UIColor *bgColor = [UIColor systemRedColor];
    NSString *text = attributedString.string;
    if ([text isEqualToString:@"HOT"]) bgColor = [UIColor systemOrangeColor];
    else if ([text isEqualToString:@"PRO"]) bgColor = [UIColor systemBlueColor];
    else if ([text isEqualToString:@"FREE"]) bgColor = [UIColor systemGreenColor];

    TTGTextTagStyle *style = [TTGTextTagStyle new];
    style.backgroundColor = bgColor;
    style.cornerRadius = 12;
    style.extraSpace = CGSizeMake(12, 6);
    style.shadowColor = [bgColor colorWithAlphaComponent:0.4];
    style.shadowOffset = CGSizeMake(0, 2);
    style.shadowOpacity = 1;
    style.shadowRadius = 4;

    TTGTextTagStyle *selectedStyle = [style copy];
    selectedStyle.backgroundColor = [bgColor colorWithAlphaComponent:0.7];
    selectedStyle.shadowOpacity = 0;

    tag.style = style;
    tag.selectedStyle = selectedStyle;
    return tag;
}

+ (TTGTextTag *)selectableAttributedTag {
    NSAttributedString *normalContent = [[NSAttributedString alloc] initWithString:@"☆ Tap to Select" attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium],
        NSForegroundColorAttributeName: [UIColor systemGrayColor]
    }];
    NSAttributedString *selectedContent = [[NSAttributedString alloc] initWithString:@"★ Selected!" attributes:@{
        NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
        NSForegroundColorAttributeName: [UIColor systemYellowColor]
    }];

    TTGTextTag *tag = [TTGTextTag new];
    tag.content = [TTGTextTagAttributedStringContent contentWithAttributedText:normalContent];
    tag.selectedContent = [TTGTextTagAttributedStringContent contentWithAttributedText:selectedContent];

    TTGTextTagStyle *style = [TTGTextTagStyle new];
    style.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.98 alpha:1.00];
    style.borderColor = [UIColor systemGrayColor];
    style.borderWidth = 1;
    style.cornerRadius = 8;
    style.extraSpace = CGSizeMake(10, 8);

    TTGTextTagStyle *selectedStyle = [style copy];
    selectedStyle.backgroundColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.25 alpha:1.00];
    selectedStyle.borderColor = [UIColor systemYellowColor];
    selectedStyle.borderWidth = 2;

    tag.style = style;
    tag.selectedStyle = selectedStyle;
    return tag;
}

@end
