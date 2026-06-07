//
//  TTGDemoTagsTableViewCell.h
//

#import <UIKit/UIKit.h>

@class TTGTextTagCollectionView;

@interface TTGDemoTagsTableViewCell : UITableViewCell

@property (strong, nonatomic) TTGTextTagCollectionView *tagView;
@property (strong, nonatomic) UILabel *label;

- (void)configureWithWords:(NSArray<NSString *> *)words;

@end
