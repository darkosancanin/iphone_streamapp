#import <UIKit/UIKit.h>

@interface PullRefreshTableViewController : UITableViewController {
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    NSString *refreshTextPull;
    NSString *refreshTextRelease;
    NSString *refreshTextLoading;
	BOOL isDragging;
    BOOL isLoading;
	UIView *loadMoreFooterView;
    UILabel *loadMoreLabel;
    UIImageView *loadMoreArrow;
    UIActivityIndicatorView *loadMoreSpinner;
    NSString *loadMoreTextPull;
    NSString *loadMoreTextRelease;
    NSString *loadMoreTextLoading;
	CGFloat actualTableViewContentHeight;
}

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *refreshTextPull;
@property (nonatomic, copy) NSString *refreshTextRelease;
@property (nonatomic, copy) NSString *refreshTextLoading;
@property (nonatomic, retain) UIView *loadMoreFooterView;
@property (nonatomic, retain) UILabel *loadMoreLabel;
@property (nonatomic, retain) UIImageView *loadMoreArrow;
@property (nonatomic, retain) UIActivityIndicatorView *loadMoreSpinner;
@property (nonatomic, copy) NSString *loadMoreTextPull;
@property (nonatomic, copy) NSString *loadMoreTextRelease;
@property (nonatomic, copy) NSString *loadMoreTextLoading;

- (void)addPullToRefreshHeader;
- (void)addLoadMoreFooter;
- (void)setUpLabelText;
- (void)adjustLocationOfLoadMoreFooterView;
- (void)startRefreshing;
- (void)refresh;
- (void)startLoadingMore;
- (void)loadMore;
- (void)stopLoading;

@end
