#import <UIKit/UIKit.h>
#import "HashTagsCategory.h"
#import "CMIndexBar.h"
@class HashTagsSection;

#define kTableViewCellTagColorBlock 1000
#define kTableViewCellTagLabel 2000

@interface HashTagsController : UIViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, CMIndexBarDelegate> {
	NSArray *hashTagsCategories;
    NSIndexPath *hashTagCollectionIndexPathToShowUsersFor;
    UITableView *hashTagsTableView;
    UISegmentedControl *categoriesSegmentedControl;
    NSMutableDictionary *sectionHeaderViews;
    CMIndexBar *indexBar;
}

@property (nonatomic, retain) NSArray *hashTagsCategories;
@property (nonatomic, retain) NSIndexPath *hashTagCollectionIndexPathToShowUsersFor;
@property (nonatomic, retain) UISegmentedControl *categoriesSegmentedControl;
@property (nonatomic, retain) UITableView *hashTagsTableView;
@property (nonatomic, retain) NSMutableDictionary *sectionHeaderViews;
@property (nonatomic, retain) CMIndexBar *indexBar;

- (void)setUpLongPressGestureRecognition;
- (void)setUpTableView;
- (void)setUpIndexBar;
- (void)setIndexBarIndexValues;
- (HashTagsCategory *)getSelectedHashTagsCategory;

@end
