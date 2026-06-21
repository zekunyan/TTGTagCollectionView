//
//  TTGTagCollectionViewTests.m
//  TTGTagCollectionViewTests
//
//  Created by zekunyan on 12/11/2015.
//  Copyright (c) 2019 zekunyan. All rights reserved.
//

@import XCTest;
#import <TTGTags/TTGTags-Swift.h>

@interface Tests : XCTestCase

@end

@implementation Tests

- (TTGTextTag *)tagWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    TTGTextTagStringContent *content = [TTGTextTagStringContent contentWithText:text
                                                                        textFont:[UIFont systemFontOfSize:fontSize]
                                                                       textColor:UIColor.blackColor];
    TTGTextTagStyle *style = [TTGTextTagStyle new];
    return [TTGTextTag tagWithContent:content style:style];
}

- (TTGTextTagCollectionView *)textTagViewWithNineTags {
    TTGTextTagCollectionView *textTagView = [TTGTextTagCollectionView new];

    for (NSInteger i = 1; i < 10; i++) {
        [textTagView addTag:[self tagWithText:@(i).description fontSize:14]];
    }

    return textTagView;
}

- (void)testAddTagAndGetTag {
    TTGTextTagCollectionView *textTagView = [TTGTextTagCollectionView new];

    [textTagView addTag:[self tagWithText:@"1" fontSize:14]];
    [textTagView addTag:[self tagWithText:@"2" fontSize:14]];
    [textTagView addTags:@[
        [self tagWithText:@"3" fontSize:14],
        [self tagWithText:@"4" fontSize:14],
        [self tagWithText:@"5" fontSize:16],
        [self tagWithText:@"6" fontSize:16],
    ]];

    XCTAssertEqual([textTagView allTags].count, 6);
    XCTAssertEqual([textTagView allNotSelectedTags].count, 6);
    XCTAssertEqual([textTagView allSelectedTags].count, 0);

    TTGTextTag *secondTag = [textTagView getTagAtIndex:1];
    TTGTextTagStringContent *secondContent = (TTGTextTagStringContent *)secondTag.content;
    XCTAssertEqualObjects(secondContent.text, @"2");
    XCTAssertNil([textTagView getTagAtIndex:100]);

    NSArray<TTGTextTag *> *tags = [textTagView getTagsInRange:NSMakeRange(1, 2)];
    XCTAssertEqual(tags.count, 2);
    XCTAssertEqualObjects(((TTGTextTagStringContent *)tags[0].content).text, @"2");
    XCTAssertEqualObjects(((TTGTextTagStringContent *)tags[1].content).text, @"3");
    XCTAssertNil([textTagView getTagsInRange:NSMakeRange(100, 100)]);

    TTGTextTag *fifthTag = [textTagView getTagAtIndex:4];
    TTGTextTagStringContent *fifthContent = (TTGTextTagStringContent *)fifthTag.content;
    XCTAssertEqual(fifthContent.textFont.pointSize, 16);
}

- (void)testInsertTag {
    TTGTextTagCollectionView *textTagView = [self textTagViewWithNineTags];
    XCTAssertEqual([textTagView allTags].count, 9);

    [textTagView insertTag:[self tagWithText:@"10" fontSize:14] atIndex:0];
    XCTAssertEqualObjects(((TTGTextTagStringContent *)[textTagView getTagAtIndex:0].content).text, @"10");

    [textTagView insertTag:[self tagWithText:@"11" fontSize:14] atIndex:100];
    XCTAssertEqual([textTagView allTags].count, 10);

    [textTagView insertTag:[self tagWithText:@"12" fontSize:14] atIndex:[textTagView allTags].count];
    TTGTextTag *lastTag = [textTagView allTags].lastObject;
    XCTAssertEqualObjects(((TTGTextTagStringContent *)lastTag.content).text, @"12");

    [textTagView insertTags:@[
        [self tagWithText:@"13" fontSize:24],
        [self tagWithText:@"14" fontSize:24],
    ] atIndex:2];
    XCTAssertEqual([textTagView allTags].count, 13);
    XCTAssertEqualObjects(((TTGTextTagStringContent *)[textTagView getTagAtIndex:2].content).text, @"13");
    XCTAssertEqualObjects(((TTGTextTagStringContent *)[textTagView getTagAtIndex:3].content).text, @"14");
}

- (void)testUpdateTag {
    TTGTextTagCollectionView *textTagView = [self textTagViewWithNineTags];

    [textTagView updateTagAtIndex:2 selected:YES];
    XCTAssertEqual([textTagView allSelectedTags].count, 1);
    XCTAssertEqualObjects(((TTGTextTagStringContent *)[textTagView allSelectedTags].lastObject.content).text, @"3");

    [textTagView updateTagAtIndex:2 withNewTag:[self tagWithText:@"changed" fontSize:40]];
    TTGTextTag *updatedTag = [textTagView getTagAtIndex:2];
    TTGTextTagStringContent *updatedContent = (TTGTextTagStringContent *)updatedTag.content;
    XCTAssertEqualObjects(updatedContent.text, @"changed");
    XCTAssertEqual(updatedContent.textFont.pointSize, 40);
}

- (void)testUpdateTagById {
    TTGTextTagCollectionView *textTagView = [self textTagViewWithNineTags];
    TTGTextTag *thirdTag = [textTagView getTagAtIndex:2];

    [textTagView updateTagById:thirdTag.tagId selected:YES];

    XCTAssertEqual([textTagView indexOfTagById:thirdTag.tagId], 2);
    XCTAssertEqual([textTagView getTagById:thirdTag.tagId], thirdTag);
    XCTAssertTrue([textTagView getTagAtIndex:2].selected);

    TTGTextTag *replacement = [self tagWithText:@"by-id" fontSize:18];
    [textTagView updateTagById:thirdTag.tagId withNewTag:replacement];
    TTGTextTagStringContent *updatedContent = (TTGTextTagStringContent *)[textTagView getTagAtIndex:2].content;
    XCTAssertEqualObjects(updatedContent.text, @"by-id");
}

- (void)testRemoveTag {
    TTGTextTagCollectionView *textTagView = [self textTagViewWithNineTags];
    XCTAssertEqual([textTagView allTags].count, 9);

    TTGTextTag *firstTag = [textTagView getTagAtIndex:0];
    [textTagView removeTag:firstTag];
    XCTAssertEqual([textTagView allTags].count, 8);
    XCTAssertEqualObjects(((TTGTextTagStringContent *)[textTagView getTagAtIndex:0].content).text, @"2");

    [textTagView removeTagAtIndex:2];
    XCTAssertEqual([textTagView allTags].count, 7);
    XCTAssertEqualObjects(((TTGTextTagStringContent *)[textTagView getTagAtIndex:2].content).text, @"5");

    [textTagView removeAllTags];
    XCTAssertEqual([textTagView allTags].count, 0);
    XCTAssertEqual([textTagView allSelectedTags].count, 0);
}

@end
