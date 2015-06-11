#import <UIKit/UIKit.h>
#import "CMIndexBar.h"
#import "StreamCategory.h"
@class StreamSection;

#define kTableViewCellTagColorBlock 1000
#define kTableViewCellTagLabel 2000

@interface StreamsController : UIViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, CMIndexBarDelegate> {
	NSArray *streamCategories;
    NSIndexPath *streamIndexPathToShowUsersFor;
    UITableView *streamsTableView;
    UISegmentedControl *categoriesSegmentedControl;
    NSMutableDictionary *sectionHeaderViews;
    CMIndexBar *indexBar;
}

@property (nonatomic, retain) NSArray *streamCategories;
@property (nonatomic, retain) NSIndexPath *streamIndexPathToShowUsersFor;
@property (nonatomic, retain) UITableView *streamsTableView;
@property (nonatomic, retain) UISegmentedControl *categoriesSegmentedControl;
@property (nonatomic, retain) NSMutableDictionary *sectionHeaderViews;
@property (nonatomic, retain) CMIndexBar *indexBar;

- (void)setUpLongPressGestureRecognition;
- (void)setUpTableView;
- (void)setUpIndexBar;
- (void)setIndexBarIndexValues;
- (StreamCategory *)getSelectedStreamCategory;

@end
