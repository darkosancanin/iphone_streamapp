#import <UIKit/UIKit.h>
#import "TweetsManagerDelegate.h"
#import "TweetsManager.h"
#import "Tweet.h"
#import "UserInfoHeaderView.h"
#import "TweetsManager.h"
#import "TweetsManagerDelegate.h"
#import "MessageView.h"

@interface TweetController : UITableViewController<UIWebViewDelegate, TweetsManagerDelegate, UIActionSheetDelegate> {
	Tweet *tweet;
	UserInfoHeaderView *userInfoHeaderView;
    TweetsManager *tweetsManager;
    NSArray *conversationTweets;
    MessageView *messageView;
    UIWebView *textWebView;
}

@property (nonatomic, retain) Tweet *tweet;
@property (nonatomic, retain) NSArray *conversationTweets;
@property (nonatomic, retain) UIWebView *textWebView;

- (id)initWithTweet:(Tweet *)theTweet;
- (void)setUpUserInfoHeaderView;
- (void)setUpTextWebView;
- (void)setUpMessageView;
- (void)setUpActionButton;
- (void)startLoadingConversationTweets;

@end
