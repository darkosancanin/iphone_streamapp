#import <Foundation/Foundation.h>
#import "Tweet.h"
#import "MessageView.h"
#import "TweetsManager.h"
#import "TweetsManagerDelegate.h"

typedef enum _TweetComposeType {
	TweetComposeTypeReply = 0,
	TweetComposeTypeQuote = 1,
    TweetComposeTypeCompose = 2
} TweetComposeType;

@interface TweetComposerController : UIViewController<UITextViewDelegate, TweetsManagerDelegate> {
    UITextView *tweetTextView;
    UILabel *textLengthLabel;
    Tweet *tweet;
    TweetComposeType tweetComposeType;
    MessageView *messageView;
    TweetsManager *tweetsManager;
    UIBarButtonItem *sendButton;
}

@property (nonatomic, retain) Tweet *tweet;

- (id)initWithTweet:(Tweet *)theTweet andTweetComposeType:(TweetComposeType)theTweetComposeType;
- (void)setUpNavigationButtons;
- (void)setUpTextField;
- (void)setUpTextLengthCounter;
- (void)setUpScreen;
- (void)setUpMessageView;
- (void)enableButtons;
- (void)disableButtons;

@end
