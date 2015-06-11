#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"
#import "TweetTypeDetails.h"
#import "TweetsManagerDelegate.h"
#import "TweetsManager.h"
#import "MessageView.h"
#import "SettingsManager.h"
#import "Global.h"

@interface TweetsController : PullRefreshTableViewController<TweetsManagerDelegate, UIActionSheetDelegate> {
	NSMutableArray *tweets;
	TweetTypeDetails *tweetTypeDetails;
	MessageView *messageView;
	int insertNewTweetsAtIndex;
	TweetsManager *tweetsManager;
    NSIndexPath *tweetIndexPathToShowUsersFor;
    UIView *noTweetsFoundView;
    UIView *noTweetsFoundForUserView;
    BOOL retweetActionsIsDisabled;
}

@property (nonatomic, retain) NSMutableArray *tweets;
@property (nonatomic, retain) TweetTypeDetails *tweetTypeDetails;
@property (nonatomic, retain) NSIndexPath *tweetIndexPathToShowUsersFor;

- (id)initWithTweetTypeDetails:(TweetTypeDetails *)newTweetTypeDetails;
- (void)showNoTweetsFoundView;
- (void)hideNoTweetsFoundView;
- (void)disableButtons;
- (void)enableButtons;
- (void)refreshEverythingButtonClicked;
- (void)loadInitialTweets;
- (void)setUpMessageView;
- (void)setUpRefreshEverythingButton;
- (void)getTweetsSinceID:(TweetID)sinceID withMaximumID:(TweetID)maxTweetID;
- (void)setUpLongPressGestureRecognition;
- (void)setUpNoTweetsFoundView;
- (void)setUpNoTweetsFoundForUserView;

@end
