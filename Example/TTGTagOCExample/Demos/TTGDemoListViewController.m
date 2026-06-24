//
//  TTGDemoListViewController.m
//

#import "TTGDemoListViewController.h"
#import "TTGDemoBasicTextTagsViewController.h"
#import "TTGDemoCustomSubviewTagsViewController.h"
#import "TTGDemoProgrammaticTagsViewController.h"
#import "TTGDemoTagsInTableViewController.h"
#import "TTGDemoHorizontalScrollTagsViewController.h"
#import "TTGDemoPullRefreshTagsViewController.h"
#import "TTGDemoPerTagStyleViewController.h"
#import "TTGDemoTagAttachmentViewController.h"
#import "TTGDemoAttributedStringTagsViewController.h"
#import "TTGDemoAnchorLayoutViewController.h"
#import "TTGDemoStackViewViewController.h"
#import "TTGDemoSelfSizingViewController.h"
#import "TTGDemoAutoLayoutFormViewController.h"
#import "TTGDemoReorderTagsViewController.h"
#import "TTGDemoSwipeSelectionTagsViewController.h"

@interface TTGDemoListItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) Class viewControllerClass;
@end

@implementation TTGDemoListItem

+ (instancetype)itemWithTitle:(NSString *)title
                       detail:(NSString *)detail
          viewControllerClass:(Class)viewControllerClass {
    TTGDemoListItem *item = [TTGDemoListItem new];
    item.title = title;
    item.detail = detail;
    item.viewControllerClass = viewControllerClass;
    return item;
}

@end

@interface TTGDemoListViewController ()
@property (nonatomic, copy) NSArray<TTGDemoListItem *> *demoItems;
@end

@implementation TTGDemoListViewController

- (instancetype)init {
    return [super initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"TTGTag";
    self.tableView.rowHeight = 60;

    self.demoItems = @[
        [TTGDemoListItem itemWithTitle:@"1. Basic text tags"
                                detail:@"TTGDemoBasicTextTagsViewController"
                   viewControllerClass:TTGDemoBasicTextTagsViewController.class],
        [TTGDemoListItem itemWithTitle:@"2. Custom UIView tags"
                                detail:@"TTGDemoCustomSubviewTagsViewController"
                   viewControllerClass:TTGDemoCustomSubviewTagsViewController.class],
        [TTGDemoListItem itemWithTitle:@"3. Programmatic APIs"
                                detail:@"Multiline tags, tagId updates, and scroll-to-tag"
                   viewControllerClass:TTGDemoProgrammaticTagsViewController.class],
        [TTGDemoListItem itemWithTitle:@"4. Tags in UITableViewCell"
                                detail:@"TTGDemoTagsInTableViewController"
                   viewControllerClass:TTGDemoTagsInTableViewController.class],
        [TTGDemoListItem itemWithTitle:@"5. Horizontal scroll & line limits"
                                detail:@"TTGDemoHorizontalScrollTagsViewController"
                   viewControllerClass:TTGDemoHorizontalScrollTagsViewController.class],
        [TTGDemoListItem itemWithTitle:@"6. Pull to refresh"
                                detail:@"TTGDemoPullRefreshTagsViewController"
                   viewControllerClass:TTGDemoPullRefreshTagsViewController.class],
        [TTGDemoListItem itemWithTitle:@"7. Each tag can be different"
                                detail:@"TTGDemoPerTagStyleViewController"
                   viewControllerClass:TTGDemoPerTagStyleViewController.class],
        [TTGDemoListItem itemWithTitle:@"8. Bind data to tag"
                                detail:@"TTGDemoTagAttachmentViewController"
                   viewControllerClass:TTGDemoTagAttachmentViewController.class],
        [TTGDemoListItem itemWithTitle:@"9. Attributed string tags"
                                detail:@"TTGDemoAttributedStringTagsViewController"
                   viewControllerClass:TTGDemoAttributedStringTagsViewController.class],
        [TTGDemoListItem itemWithTitle:@"10. Anchor constraint layout"
                                detail:@"TTGDemoAnchorLayoutViewController"
                   viewControllerClass:TTGDemoAnchorLayoutViewController.class],
        [TTGDemoListItem itemWithTitle:@"11. UIStackView integration"
                                detail:@"TTGDemoStackViewViewController"
                   viewControllerClass:TTGDemoStackViewViewController.class],
        [TTGDemoListItem itemWithTitle:@"12. Self-sizing"
                                detail:@"TTGDemoSelfSizingViewController"
                   viewControllerClass:TTGDemoSelfSizingViewController.class],
        [TTGDemoListItem itemWithTitle:@"13. Auto Layout form"
                                detail:@"TTGDemoAutoLayoutFormViewController"
                   viewControllerClass:TTGDemoAutoLayoutFormViewController.class],
        [TTGDemoListItem itemWithTitle:@"14. Reorder & delete"
                                detail:@"Long-press drag to reorder tags or drop one into the delete zone"
                   viewControllerClass:TTGDemoReorderTagsViewController.class],
        [TTGDemoListItem itemWithTitle:@"15. Swipe select"
                                detail:@"Drag across tags to select multiple items"
                   viewControllerClass:TTGDemoSwipeSelectionTagsViewController.class],
    ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DemoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    TTGDemoListItem *item = self.demoItems[(NSUInteger)indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.detail;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TTGDemoListItem *item = self.demoItems[(NSUInteger)indexPath.row];
    UIViewController *viewController = [[item.viewControllerClass alloc] init];
    viewController.title = item.title;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
