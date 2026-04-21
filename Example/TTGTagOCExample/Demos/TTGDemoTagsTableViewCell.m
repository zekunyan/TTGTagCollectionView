//
//  TTGDemoTagsTableViewCell.m
//

#import "TTGDemoTagsTableViewCell.h"
#import <TTGTags/TTGTags-Swift.h>

@implementation TTGDemoTagsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    self.tagView.manualCalculateHeight = YES;
}

- (void)configureWithWords:(NSArray<NSString *> *)words {
    [self.tagView removeAllTags];

    NSMutableArray<TTGTextTag *> *tags = [NSMutableArray array];
    for (NSString *word in words) {
        TTGTextTag *t = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:word]
                                             style:[TTGTextTagStyle new]];
        t.selectedStyle.backgroundColor = [UIColor greenColor];
        [tags addObject:t];
    }
    [self.tagView addTags:tags];

    self.tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 16;

    if (words.count > 0) {
        for (NSInteger i = 0; i < 3; i++) {
            [self.tagView updateTagAtIndex:arc4random_uniform((uint32_t)words.count) selected:YES];
        }
    }
    [self.tagView reload];
}

@end
