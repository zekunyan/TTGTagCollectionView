//
//  TTGDemoTagsTableViewCell.h
//

#import <UIKit/UIKit.h>

@class TTGTextTagCollectionView;

@interface TTGDemoTagsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)configureWithWords:(NSArray<NSString *> *)words;

@end
