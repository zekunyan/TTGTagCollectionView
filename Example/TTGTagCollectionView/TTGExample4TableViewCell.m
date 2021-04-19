//
//  TTGExample4TableViewCell.m
//  TTGTagCollectionView
//
//  Created by zekunyan on 2016/10/1.
//  Copyright (c) 2019 zekunyan. All rights reserved.
//

#import "TTGExample4TableViewCell.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface TTGExample4TableViewCell ()
@end

@implementation TTGExample4TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Alignment
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    // Use manual calculate height
    _tagView.manualCalculateHeight = YES;
}

- (void)setTags:(NSArray<NSString *> *)tags {
    [_tagView removeAllTags];

    NSMutableArray *textTags = [NSMutableArray new];
    for (NSString *string in tags) {
        TTGTextTag *textTag = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:string] style:[TTGTextTagStyle new]];
        textTag.selectedStyle.backgroundColor = [UIColor greenColor];
        [textTags addObject:textTag];
    }
    [_tagView addTags:textTags];

    // Use manual height, update preferredMaxLayoutWidth
    _tagView.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 16;
    
    // Random selected
    for (NSInteger i = 0; i < 3; i++) {
        [_tagView updateTagAtIndex:arc4random_uniform((uint32_t)tags.count) selected:YES];
    }    
}

@end
