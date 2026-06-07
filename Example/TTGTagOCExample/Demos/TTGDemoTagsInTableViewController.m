//
//  TTGDemoTagsInTableViewController.m
//

#import "TTGDemoTagsInTableViewController.h"
#import "TTGDemoUI.h"
#import "TTGDemoTagsTableViewCell.h"
#import "TTGTagSampleData.h"
#import <TTGTags/TTGTags-Swift.h>

static const NSInteger kDemoRowCount = 50;

@interface TTGDemoTagsInTableViewController ()
@property (nonatomic, copy) NSArray<NSString *> *wordPool;
@property (nonatomic, strong) NSMutableArray<NSArray<TTGTextTag *> *> *rows;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *rowHeightCache;
@end

@implementation TTGDemoTagsInTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.tableView.backgroundColor = UIColor.systemBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    [self.tableView registerClass:TTGDemoTagsTableViewCell.class
           forCellReuseIdentifier:NSStringFromClass([TTGDemoTagsTableViewCell class])];
    [self configureHeader];

    self.wordPool = [TTGTagSampleData shortSampleWords];
    self.rowHeightCache = [NSMutableDictionary dictionary];
    self.rows = [NSMutableArray arrayWithCapacity:kDemoRowCount];
    NSUInteger poolCount = self.wordPool.count;
    for (NSInteger i = 0; i < kDemoRowCount; i++) {
        NSUInteger len = MAX(1, i % (poolCount + 1));
        NSRange range = NSMakeRange(0, len);
        NSArray<NSString *> *words = [self.wordPool subarrayWithRange:range];
        NSMutableArray<TTGTextTag *> *tags = [NSMutableArray arrayWithCapacity:words.count];
        for (NSUInteger tagIndex = 0; tagIndex < words.count; tagIndex++) {
            TTGTextTag *tag = [TTGDemoUI tagWithText:words[tagIndex]];
            tag.selected = [self shouldPreselectTagAtIndex:tagIndex tagCount:words.count];
            [tags addObject:tag];
        }
        [self.rows addObject:tags];
    }
}

- (void)configureHeader {
    UILabel *titleLabel = [TTGDemoUI titleLabel:@"Tags in UITableViewCell"];
    UILabel *descriptionLabel =
        [TTGDemoUI descriptionLabel:@"Each row owns a TTGTextTagCollectionView. UITableViewAutomaticDimension reads the tag view height as the tags wrap into multiple lines."];
    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[ titleLabel, descriptionLabel ]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 8;
    stack.layoutMargins = UIEdgeInsetsMake(16, 16, 16, 16);
    stack.layoutMarginsRelativeArrangement = YES;
    stack.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 104);
    self.tableView.tableHeaderView = stack;
}

- (BOOL)shouldPreselectTagAtIndex:(NSUInteger)index tagCount:(NSUInteger)tagCount {
    if (tagCount == 0) {
        return NO;
    }
    NSUInteger selectedCount = MIN(3, tagCount);
    for (NSUInteger slot = 0; slot < selectedCount; slot++) {
        if (index == (slot * 7 + tagCount / 2) % tagCount) {
            return YES;
        }
    }
    return NO;
}

- (CGFloat)cachedHeightForTags:(NSArray<TTGTextTag *> *)tags tableWidth:(CGFloat)tableWidth row:(NSInteger)row {
    CGFloat width = MAX(0, tableWidth);
    NSString *cacheKey = [NSString stringWithFormat:@"%ld|%.0f", (long)row, round(width)];
    NSNumber *cachedHeight = self.rowHeightCache[cacheKey];
    if (cachedHeight != nil) {
        return cachedHeight.doubleValue;
    }

    CGFloat tagWidth = MAX(0, width - 32);
    CGSize tagSize = [TTGTextTagCollectionView contentSizeForTags:tags
                                                            width:tagWidth
                                                  scrollDirection:TTGTagCollectionScrollDirectionVertical
                                                        alignment:TTGTagCollectionAlignmentFillByExpandingWidth
                                                    numberOfLines:0
                                                horizontalSpacing:6
                                                  verticalSpacing:6
                                                     contentInset:UIEdgeInsetsMake(8, 8, 8, 8)];
    CGFloat titleHeight = ceil([UIFont systemFontOfSize:13 weight:UIFontWeightSemibold].lineHeight);
    CGFloat height = 12 + titleHeight + 8 + ceil(tagSize.height) + 12;
    self.rowHeightCache[cacheKey] = @(height);
    return height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTGDemoTagsTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TTGDemoTagsTableViewCell class])
                                          forIndexPath:indexPath];
    NSArray<TTGTextTag *> *tags = self.rows[(NSUInteger)indexPath.row];
    CGFloat availableWidth = MAX(0, CGRectGetWidth(tableView.bounds) - 32);
    [cell configureWithTags:tags availableWidth:availableWidth];
    cell.label.text = [NSString stringWithFormat:@"Row %ld · %lu tags", (long)indexPath.row, (unsigned long)tags.count];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cachedHeightForTags:self.rows[(NSUInteger)indexPath.row]
                          tableWidth:CGRectGetWidth(tableView.bounds)
                                 row:indexPath.row];
}

@end
