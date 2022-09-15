//
//  TTGExample7ViewController.m
//  TTGTagCollectionView
//
//  Created by zekunyan on 2017/3/4.
//  Copyright (c) 2019 zekunyan. All rights reserved.
//

#import "TTGExample7ViewController.h"
#import <TTGTags/TTGTextTagCollectionView.h>

@interface TTGExample7ViewController () <TTGTextTagCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
@end

@implementation TTGExample7ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *tags = @[@"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views",
                      @"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views"];
    
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    NSUInteger location = 0;
    NSUInteger length = 8;
    
    [self.class addBatchTagsWithStrings:tags
                                  range:NSMakeRange(location, length)
                              toTagView:_tagView
                        backgroundColor:[UIColor colorWithRed:0.24 green:0.72 blue:0.94 alpha:1.00]
                             attachment:@{@"key": @"1"}];
    
    location += length;
    [self.class addBatchTagsWithStrings:tags
                                  range:NSMakeRange(location, length)
                              toTagView:_tagView
                        backgroundColor:[UIColor colorWithRed:0.30 green:0.72 blue:0.53 alpha:1.00]
                             attachment:@{@"key": @"2"}];
    
    location += length;
    [self.class addBatchTagsWithStrings:tags
                                  range:NSMakeRange(location, length)
                              toTagView:_tagView
                        backgroundColor:[UIColor colorWithRed:0.97 green:0.64 blue:0.27 alpha:1.00]
                             attachment:@{@"key": @"3"}];
    
    location += length;
    [self.class addBatchTagsWithStrings:tags
                                  range:NSMakeRange(location, length)
                              toTagView:_tagView
                        backgroundColor:[UIColor colorWithRed:0.73 green:0.91 blue:0.41 alpha:1.00]
                             attachment:@{@"key": @"4"}];
    
    location += length;
    [self.class addBatchTagsWithStrings:tags
                                  range:NSMakeRange(location, length)
                              toTagView:_tagView
                        backgroundColor:[UIColor colorWithRed:0.35 green:0.35 blue:0.36 alpha:1.00]
                             attachment:@{@"key": @"5"}];
    
    location += length;
    [self.class addBatchTagsWithStrings:tags
                                  range:NSMakeRange(location, length)
                              toTagView:_tagView
                        backgroundColor:[UIColor colorWithRed:1.00 green:0.41 blue:0.42 alpha:1.00]
                             attachment:@{@"key": @"6"}];
    
    location += length;
    [self.class addBatchTagsWithStrings:tags
                                  range:NSMakeRange(location, length)
                              toTagView:_tagView
                        backgroundColor:[UIColor colorWithRed:0.50 green:0.86 blue:0.90 alpha:1.00]
                             attachment:@{@"key": @"7"}];
    
    location += length;
    [self.class addBatchTagsWithStrings:tags
                                  range:NSMakeRange(location, length)
                              toTagView:_tagView
                        backgroundColor:[UIColor colorWithRed:0.33 green:0.23 blue:0.34 alpha:1.00]
                             attachment:@{@"key": @"8"}];
    
    _tagView.delegate = self;
    [_tagView reload];
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSUInteger)index {
    NSLog(@"Did tap: %@, config extra: %@", tag.content, tag.attachment);
}

+ (void)addBatchTagsWithStrings:(NSArray<NSString *> *)strings
                          range:(NSRange)range
                      toTagView:(TTGTextTagCollectionView *)tagView
                backgroundColor:(UIColor *)backgroundColor
                     attachment:(id)attachment {
    
    static TTGTextTagStyle *defaultStyle = nil;
    static TTGTextTagStringContent *defaultContent = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultStyle = [TTGTextTagStyle new];
        defaultStyle.backgroundColor = [UIColor whiteColor];
        defaultStyle.borderColor = [UIColor whiteColor];
        defaultStyle.borderWidth = 1;
        defaultStyle.cornerRadius = 4;
        defaultStyle.extraSpace = CGSizeMake(8, 8);
        defaultStyle.shadowColor = [UIColor blackColor];
        defaultStyle.shadowOpacity = 0.3;
        defaultStyle.shadowRadius = 2;
        defaultStyle.shadowOffset = CGSizeMake(1, 1);
        
        defaultContent = [TTGTextTagStringContent new];
        defaultContent.textFont = [UIFont systemFontOfSize:20];
        defaultContent.textColor = [UIColor whiteColor];
    });
    
    for (NSString *text in [strings subarrayWithRange:range]) {
        TTGTextTag *tag = [TTGTextTag new];
        
        TTGTextTagStyle *style = [defaultStyle copy];
        style.backgroundColor = backgroundColor;
        
        TTGTextTagStyle *selectedStyle = [style copy];
        selectedStyle.backgroundColor = [self.class getRevertColor:style.backgroundColor];
        selectedStyle.borderColor = [UIColor blackColor];
        selectedStyle.cornerRadius = 8;
        selectedStyle.shadowColor = [UIColor greenColor];
        
        TTGTextTagStringContent *content = [defaultContent copy];
        content.text = text;
        
        tag.style = style;
        tag.selectedStyle = selectedStyle;
        tag.content = content;
        tag.attachment = attachment;
        [tagView addTag:tag];
    }
    
    [tagView updateTagAtIndex:range.location + arc4random_uniform((uint32_t)range.length) selected:YES];
}

+ (UIColor *)getRevertColor:(UIColor *)color {
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    return [UIColor colorWithRed:1 - red green:1 - green blue:1 - blue alpha:1];
}

@end
