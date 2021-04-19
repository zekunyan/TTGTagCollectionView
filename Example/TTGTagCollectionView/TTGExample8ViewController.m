//
//  TTGExample8ViewController.m
//  TTGTagCollectionView_Example
//
//  Created by zekunyan on 24/03/2018.
//  Copyright (c) 2019 zekunyan. All rights reserved.
//

#import "TTGExample8ViewController.h"
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

#pragma mark - CustomTagData

@interface CustomTagData: NSObject
@property (nonatomic, strong) NSString *info;
@end

@implementation CustomTagData
- (NSString *)description {
    return [NSString stringWithFormat:@"I am CustomTagData, info is: %@", _info];
}
@end

#pragma mark - TTGExample8ViewController

@interface TTGExample8ViewController () <TTGTextTagCollectionViewDelegate>
@property (nonatomic, strong) TTGTextTagCollectionView *tagView;
@property (nonatomic, strong) UITextView *infoTextView;
@end

@implementation TTGExample8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create view
    _tagView = [TTGTextTagCollectionView new];
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    _tagView.layer.borderColor = [UIColor grayColor].CGColor;
    _tagView.layer.borderWidth = 1;
    _tagView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_tagView];
    
    _infoTextView = [UITextView new];
    _infoTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _infoTextView.layer.borderWidth = 1;
    _infoTextView.textColor = [UIColor grayColor];
    _infoTextView.font = [UIFont systemFontOfSize:12];
    _infoTextView.translatesAutoresizingMaskIntoConstraints = NO;
    _infoTextView.contentInset = UIEdgeInsetsZero;
    _infoTextView.textContainerInset = UIEdgeInsetsZero;
    _infoTextView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_infoTextView];
    
    // TagView Layout
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[tagView]-20-|"
                                                                    options:(NSLayoutFormatOptions) 0 metrics:nil
                                                                      views:@{@"tagView": _tagView}];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_tagView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.topLayoutGuide
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1 constant:20];
    [self.view addConstraint:topConstraint];
    [self.view addConstraints:hConstraints];
    
    // Info textView layout
    hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[infoView]-20-|"
                                                           options:(NSLayoutFormatOptions) 0 metrics:nil
                                                             views:@{@"infoView": _infoTextView}];
    topConstraint = [NSLayoutConstraint constraintWithItem:_infoTextView
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:_tagView
                                                 attribute:NSLayoutAttributeBottom
                                                multiplier:1 constant:20];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_infoTextView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1 constant:-20];
    [self.view addConstraint:topConstraint];
    [self.view addConstraints:hConstraints];
    [self.view addConstraint:bottomConstraint];
    
    TTGTextTagStringContent *defaultContent = [TTGTextTagStringContent new];
    
    TTGTextTagStyle *defaultStyle = [TTGTextTagStyle new];
    defaultStyle.backgroundColor = [UIColor colorWithRed:0.24 green:0.72 blue:0.94 alpha:1.00];
    defaultStyle.borderColor = [UIColor whiteColor];
    defaultStyle.borderWidth = 1;
    defaultStyle.cornerRadius = 4;
    defaultStyle.extraSpace = CGSizeMake(8, 8);
    defaultStyle.shadowColor = [UIColor blackColor];
    defaultStyle.shadowOpacity = 0.3;
    defaultStyle.shadowRadius = 2;
    defaultStyle.shadowOffset = CGSizeMake(1, 1);
    
    // Bind CustomTagData
    CustomTagData *customTagData = [CustomTagData new];
    customTagData.info = @"I am TTGTag custom data.";
    
    TTGTextTag *tag1 = [TTGTextTag new];
    tag1.attachment = customTagData;
    tag1.style = defaultStyle;
    tag1.content = defaultContent;
    ((TTGTextTagStringContent *)tag1.content).text = @"Bind CustomTagData";
    [_tagView addTag:tag1];
    
    // Bind NSDictionary
    NSDictionary *dict = @{@"info": @"I am TTGTag NSDictionary data"};
    
    TTGTextTag *tag2 = [TTGTextTag new];
    tag2.attachment = dict;
    tag2.style = defaultStyle;
    tag2.content = defaultContent;
    ((TTGTextTagStringContent *)tag2.content).text = @"Bind NSDictionary";
    [_tagView addTag:tag2];
    
    // Bind String1
    TTGTextTag *tag3 = [TTGTextTag new];
    tag3.attachment = @"String1";
    tag3.style = defaultStyle;
    tag3.content = defaultContent;
    ((TTGTextTagStringContent *)tag3.content).text = @"Bind String1";
    [_tagView addTag:tag3];
    
    // Bind String2
    TTGTextTag *tag4 = [TTGTextTag new];
    tag4.attachment = @"String2";
    tag4.style = defaultStyle;
    tag4.content = defaultContent;
    ((TTGTextTagStringContent *)tag4.content).text = @"Bind String2";
    [_tagView addTag:tag4];
    
    // Reload
    [_tagView reload];
    
    // Set delegate
    _tagView.delegate = self;
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSUInteger)index {
    _infoTextView.text = [NSString stringWithFormat:@"%@Did Tap:\n%@\n\n", _infoTextView.text, tag.attachment];
}

@end
