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

- (void)testExample {
    TTGTextTagCollectionView *textTagView = [TTGTextTagCollectionView new];
    
    // addTag:
    [textTagView addTag:@"abc"];
    [textTagView addTag:@"abc"];
    [textTagView addTag:@"abc"];
    [textTagView addTag:@"abc"];
    XCTAssert(textTagView.allTags.count == 4);
    
    // addTags
    [textTagView addTags:@[@"efg", @"efg"]];
    XCTAssert(textTagView.allTags.count == 6);
    
    // removeTag:
    [textTagView removeTag:@"abc"];
    XCTAssert(textTagView.allTags.count == 2);
    
    // removeTagAtIndex:
    [textTagView removeTagAtIndex:1];
    XCTAssert(textTagView.allTags.count == 1);
    
    // removeAllTags
    [textTagView removeAllTags];
    XCTAssert(textTagView.allTags.count == 0);
    
    // setTagAtIndex:selected:
    [textTagView addTag:@"abc"];
    [textTagView addTag:@"abc"];
    [textTagView addTag:@"abc"];
    [textTagView addTag:@"abc"];
    [textTagView setTagAtIndex:1 selected:YES];
    [textTagView setTagAtIndex:2 selected:YES];
    XCTAssert(textTagView.allSelectedTags.count == 2);
    XCTAssert(textTagView.allNotSelectedTags.count == 2);
}

@end

