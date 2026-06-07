//
//  TTGDemoTagsTableViewCell.h
//

#import <UIKit/UIKit.h>

@class TTGTextTagCollectionView;
@class TTGTextTag;

@interface TTGDemoTagsTableViewCell : UITableViewCell

@property (strong, nonatomic) TTGTextTagCollectionView *tagView;
@property (strong, nonatomic) UILabel *label;

- (void)configureWithTags:(NSArray<TTGTextTag *> *)tags availableWidth:(CGFloat)availableWidth;

@end
