//
//  TTGTagCollectionViewTests.m
//  TTGTagCollectionViewTests
//
//  Created by zekunyan on 12/11/2015.
//  Copyright (c) 2015 zekunyan. All rights reserved.
//

@import XCTest;
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (TTGTextTagCollectionView *)getTextCaseTextTagView {
    TTGTextTagCollectionView *textTagView = [TTGTextTagCollectionView new];
    
    for (NSInteger i = 1; i < 10; i++) {
        [textTagView addTag:@(i).description];
    }
    
    return textTagView;
}

- (void)testAddTagAndGetTag {
    TTGTextTagCollectionView *textTagView = [TTGTextTagCollectionView new];
    
    // addTag:
    [textTagView addTag:@"1"];
    [textTagView addTag:@"2"];
    
    // addTags:
    [textTagView addTags:@[@"3", @"4"]];
    [textTagView addTags:@[@"5", @"6"]];
    
    // addTag:withConfig
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    config.tagTextFont = [UIFont systemFontOfSize:14];
    [textTagView addTag:@"7" withConfig:config];
    
    // addTags:withConfig:
    config.tagTextFont = [UIFont systemFontOfSize:16];
    [textTagView addTags:@[@"8", @"9"] withConfig:config];
    
    // Check
    XCTAssert([textTagView allTags].count == 9);
    XCTAssert([textTagView allNotSelectedTags].count == 9);
    XCTAssert([textTagView allSelectedTags].count == 0);
    
    XCTAssert([[textTagView getTagAtIndex:1] isEqualToString:@"2"]);
    XCTAssert([[textTagView getTagAtIndex:4] isEqualToString:@"5"]);
    XCTAssert([textTagView getTagAtIndex:100] == nil);
    XCTAssert([textTagView getTagAtIndex:-1] == nil);
    
    NSArray <NSString *> *tags = [textTagView getTagsInRange:NSMakeRange(1, 2)];
    XCTAssert(tags.count == 2);
    XCTAssert([tags[0] isEqualToString:@"2"]);
    XCTAssert([tags[1] isEqualToString:@"3"]);
    
    tags = [textTagView getTagsInRange:NSMakeRange(100, 100)];
    XCTAssert(tags == nil);
    
    config = [textTagView getConfigAtIndex:6];
    XCTAssert(config.tagTextFont.pointSize == 14);
    
    config = [textTagView getConfigAtIndex:100];
    XCTAssert(config == nil);
    
    NSArray <TTGTextTagConfig *> *configs = [textTagView getConfigsInRange:NSMakeRange(7, 2)];
    XCTAssert(configs.count == 2);
    XCTAssert(configs[0].tagTextFont.pointSize == 16);
    XCTAssert(configs[1].tagTextFont.pointSize == 16);
    
    configs = [textTagView getConfigsInRange:NSMakeRange(100, 100)];
    XCTAssert(configs == nil);
}

- (void)testInsertTag {
    TTGTextTagCollectionView *textTagView = [self getTextCaseTextTagView];
    XCTAssert([textTagView allTags].count == 9);
    
    [textTagView insertTag:@"10" atIndex:0];
    XCTAssert([[textTagView getTagAtIndex:0] isEqualToString:@"10"]);
    
    [textTagView insertTag:@"11" atIndex:100];
    [textTagView insertTag:@"11" atIndex:-1];
    XCTAssert([textTagView allTags].count == 10);
    
    [textTagView insertTag:@"12" atIndex:[textTagView allTags].count];
    XCTAssert([[textTagView getTagAtIndex:textTagView.allTags.count - 1] isEqualToString:@"12"]);
    
    textTagView = [self getTextCaseTextTagView];
    [textTagView insertTags:@[@"13", @"14"] atIndex:2];
    XCTAssert([textTagView allTags].count == 11);
    XCTAssert([[textTagView getTagAtIndex:2] isEqualToString:@"13"]);
    XCTAssert([[textTagView getTagAtIndex:3] isEqualToString:@"14"]);
    XCTAssert([[textTagView getTagAtIndex:4] isEqualToString:@"3"]);
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    config.tagTextFont = [UIFont systemFontOfSize:32];
    textTagView = [self getTextCaseTextTagView];
    [textTagView insertTag:@"15" atIndex:6 withConfig:config];
    XCTAssert([textTagView allTags].count == 10);
    XCTAssert([textTagView getConfigAtIndex:6].tagTextFont.pointSize == 32);
    
    textTagView = [self getTextCaseTextTagView];
    config.tagTextFont = [UIFont systemFontOfSize:24];
    [textTagView insertTags:@[@"16", @"17"] atIndex:5 withConfig:config];
    XCTAssert([textTagView getConfigAtIndex:5].tagTextFont.pointSize == [textTagView getConfigAtIndex:6].tagTextFont.pointSize);
}

- (void)testUpdateTag {
    TTGTextTagCollectionView *textTagView = [self getTextCaseTextTagView];
    XCTAssert([textTagView allTags].count == 9);
    
    [textTagView setTagAtIndex:2 selected:YES];
    XCTAssert([textTagView allSelectedTags].count == 1);
    XCTAssert([[textTagView allSelectedTags].lastObject isEqualToString:@"3"]);
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    config.tagTextFont = [UIFont systemFontOfSize:40];
    [textTagView setTagAtIndex:2 withConfig:config];
    XCTAssert([textTagView getConfigAtIndex:2].tagTextFont.pointSize == 40);
    
    config.tagTextFont = [UIFont systemFontOfSize:10];
    [textTagView setTagsInRange:NSMakeRange(4, 2) withConfig:config];
    XCTAssert([textTagView getConfigAtIndex:4].tagTextFont.pointSize == 10);
    XCTAssert([textTagView getConfigAtIndex:5].tagTextFont.pointSize == 10);
}

- (void)testRemoveTag {
    TTGTextTagCollectionView *textTagView = [self getTextCaseTextTagView];
    XCTAssert([textTagView allTags].count == 9);
    
    [textTagView addTag:@"1"];
    [textTagView addTag:@"1"];
    [textTagView addTag:@"1"];
    [textTagView addTag:@"1"];
    XCTAssert([textTagView allTags].count == 13);
    
    [textTagView removeTag:@"1"];
    XCTAssert([textTagView allTags].count == 8);
    
    [textTagView removeTagAtIndex:-1];
    [textTagView removeTagAtIndex:100];
    [textTagView removeTag:@"haha"];
    XCTAssert([textTagView allTags].count == 8);

    [textTagView removeTagAtIndex:2];
    XCTAssert([textTagView allTags].count == 7);
    XCTAssert([[textTagView getTagAtIndex:2] isEqualToString:@"5"]);
    
    [textTagView removeAllTags];
    XCTAssert([textTagView allTags].count == [textTagView allSelectedTags].count);
}

@end

