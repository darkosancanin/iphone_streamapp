#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"

#define REFRESH_HEADER_HEIGHT 52.0f
#define LOADMORE_FOOTER_HEIGHT 52.0f
#define VISIBLE_TABLE_VIEW_HEIGHT 367

@implementation PullRefreshTableViewController

@synthesize refreshTextPull, refreshTextRelease, refreshTextLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
@synthesize loadMoreTextPull, loadMoreTextRelease, loadMoreTextLoading, loadMoreFooterView, loadMoreLabel, loadMoreArrow, loadMoreSpinner;

- (void)setUpLabelText {
	refreshTextPull = [[NSString alloc] initWithString:@"Pull down to load new tweets..."];
	refreshTextRelease = [[NSString alloc] initWithString:@"Release to load new tweets..."];
	refreshTextLoading = [[NSString alloc] initWithString:@"Loading..."];
	loadMoreTextPull = [[NSString alloc] initWithString:@"Pull up to load older tweets..."];
	loadMoreTextRelease = [[NSString alloc] initWithString:@"Release to load older tweets..."];
	loadMoreTextLoading = [[NSString alloc] initWithString:@"Loading..."];	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setUpLabelText];
    [self addPullToRefreshHeader];
	[self addLoadMoreFooter];
	actualTableViewContentHeight = -1;
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];

    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
	refreshLabel.shadowColor = [UIColor lightGrayColor];
	refreshLabel.shadowOffset = CGSizeMake(0.8,0.8);
    refreshLabel.text = refreshTextPull;

    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(45, (REFRESH_HEADER_HEIGHT - 32) / 2, 20, 32);

    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(90, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;

    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.tableView addSubview:refreshHeaderView];
}

- (void)addLoadMoreFooter {
    loadMoreFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, VISIBLE_TABLE_VIEW_HEIGHT, 320, LOADMORE_FOOTER_HEIGHT)];
	loadMoreFooterView.hidden = YES;
    loadMoreFooterView.backgroundColor = [UIColor clearColor];
	
    loadMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, LOADMORE_FOOTER_HEIGHT)];
    loadMoreLabel.backgroundColor = [UIColor clearColor];
    loadMoreLabel.font = [UIFont boldSystemFontOfSize:12.0];
    loadMoreLabel.textAlignment = UITextAlignmentCenter;
	loadMoreLabel.shadowColor = [UIColor lightGrayColor];
	loadMoreLabel.shadowOffset = CGSizeMake(0.8,0.8);
	
    loadMoreArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    loadMoreArrow.frame = CGRectMake(45, (LOADMORE_FOOTER_HEIGHT - 32) / 2, 20, 32);
	[loadMoreArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
	
    loadMoreSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadMoreSpinner.frame = CGRectMake(90, (LOADMORE_FOOTER_HEIGHT - 20) / 2, 20, 20);
    loadMoreSpinner.hidesWhenStopped = YES;
	
    [loadMoreFooterView addSubview:loadMoreLabel];
    [loadMoreFooterView addSubview:loadMoreArrow];
    [loadMoreFooterView addSubview:loadMoreSpinner];
    [self.tableView addSubview:loadMoreFooterView];
}

- (CGFloat)getTableViewContentHeight{
	if(actualTableViewContentHeight < VISIBLE_TABLE_VIEW_HEIGHT){
		return VISIBLE_TABLE_VIEW_HEIGHT;
	} else{
		return actualTableViewContentHeight;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
	if(actualTableViewContentHeight != scrollView.contentSize.height){
		[self adjustLocationOfLoadMoreFooterView];
	}
}

- (void)adjustLocationOfLoadMoreFooterView{
	actualTableViewContentHeight = self.tableView.contentSize.height;
	loadMoreFooterView.hidden = NO;
	loadMoreFooterView.frame = CGRectMake(0, [self getTableViewContentHeight], 320, LOADMORE_FOOTER_HEIGHT);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!isDragging) return;
	if (isLoading) {
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging) {
		if(scrollView.contentOffset.y > ([self getTableViewContentHeight] - VISIBLE_TABLE_VIEW_HEIGHT)){
			[UIView beginAnimations:nil context:NULL];
			if (scrollView.contentOffset.y > ([self getTableViewContentHeight] - VISIBLE_TABLE_VIEW_HEIGHT + LOADMORE_FOOTER_HEIGHT)) {
				loadMoreLabel.text = self.loadMoreTextRelease;
				[loadMoreArrow layer].transform = CATransform3DMakeRotation(0, 0, 0, 1);
			} else { 
				loadMoreLabel.text = self.loadMoreTextPull;
				[loadMoreArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
			}
			[UIView commitAnimations];
		}
		else if(scrollView.contentOffset.y < 0){
			[UIView beginAnimations:nil context:NULL];
			if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
				refreshLabel.text = self.refreshTextRelease;
				[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
			} else { 
				refreshLabel.text = self.refreshTextPull;
				[refreshArrow layer].transform = CATransform3DMakeRotation(0, 0, 0, 1);
			}
			[UIView commitAnimations];
		}
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        [self startRefreshing];
    }
	else if (scrollView.contentOffset.y > ([self getTableViewContentHeight] - VISIBLE_TABLE_VIEW_HEIGHT + LOADMORE_FOOTER_HEIGHT)) {
		[self startLoadingMore];
	}
}

- (void)startLoadingMore {
    isLoading = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	CGFloat contentHeight = self.tableView.contentSize.height;
	if(contentHeight < VISIBLE_TABLE_VIEW_HEIGHT){
		contentHeight = VISIBLE_TABLE_VIEW_HEIGHT;
	}
	self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, contentHeight + LOADMORE_FOOTER_HEIGHT);
	loadMoreLabel.text = self.loadMoreTextLoading;
    loadMoreArrow.hidden = YES;
    [loadMoreSpinner startAnimating];
    [UIView commitAnimations];
    [self loadMore];
}

- (void)stopLoading {
    isLoading = NO;
	[self adjustLocationOfLoadMoreFooterView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [loadMoreArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)loadMore {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoadingMore at the end.
    [self performSelector:@selector(stopLoadingMore) withObject:nil afterDelay:2.0];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    refreshLabel.text = self.refreshTextPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
	
	loadMoreLabel.text = self.loadMoreTextPull;
    loadMoreArrow.hidden = NO;
    [loadMoreSpinner stopAnimating];
}

- (void)startRefreshing {
    isLoading = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.refreshTextLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    [self refresh];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopRefreshing at the end.
    [self performSelector:@selector(stopRefreshing) withObject:nil afterDelay:2.0];
}

- (void)dealloc {
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshArrow release];
    [refreshSpinner release];
    [refreshTextPull release];
    [refreshTextRelease release];
    [refreshTextLoading release];
	[loadMoreFooterView release];
    [loadMoreLabel release];
    [loadMoreArrow release];
    [loadMoreSpinner release];
    [loadMoreTextPull release];
    [loadMoreTextRelease release];
    [loadMoreTextLoading release];
    [super dealloc];
}

@end
