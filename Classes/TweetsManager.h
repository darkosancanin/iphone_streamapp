#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "TweetsManagerDelegate.h"
#import "Tweet.h"
#import "Stream.h"
#import "HashTagCollection.h"
#import "OAuthCore.h"

typedef enum _TwitterResponseType {
	TwitterResponseTypeTweetSearch = 0,
    TwitterResponseTypeUser = 1,
    TwitterResponseTypeTweetConversationSearch = 2,
    TwitterResponseTypeUserTimeLine = 3,
    TwitterResponseTypeRetweet = 4,
    TwitterResponseTypeCreateTweet = 5
} TwitterResponseType;

@interface TweetsManager : NSObject<ASIHTTPRequestDelegate> {
	id<TweetsManagerDelegate> delegate;
	ASIHTTPRequest *asiHttpRequest;
	TwitterResponseType currentTwitterResponseType;
}

@property (nonatomic, assign) id<TweetsManagerDelegate> delegate;
@property (nonatomic, retain) ASIHTTPRequest *asiHttpRequest;

- (void)returnTweetsTestData;
- (void)returnUserTestData;
- (void)sendRequestToTwitterToUrl:(NSMutableString *)url andSinceID:(TweetID)sinceID andMaximumID:(TweetID)maxID andTwitterResponseType:(TwitterResponseType)twitterResponseType andUserInfo:(NSDictionary *)userInfo;
- (void)parseTweetSearchResults:(NSDictionary *)responseDictionary;
- (void)parseTweetConversationSearchResults:(NSDictionary *)responseDictionary;
- (void)parseUserDetails:(NSDictionary *)responseDictionary;
- (void)parseUserTimeLine:(NSDictionary *)responseDictionary;
- (NSArray *)getParsedTweetsSearchResults:(NSDictionary *)responseDictionary;
- (void)setUpRequestAndStartAsynchronousRequest;

- (id)initWithTweetsManagerDelegate:(id<TweetsManagerDelegate>)tweetsManagerDelegate;
- (void)getTweetsForUserNames:(NSArray *)userNames sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID;
- (void)getTweetsForStream:(Stream *)stream sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID;
- (void)getTweetsForHashTag:(NSString *)hashTag sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID;
- (void)getTweetsForHashTagCollection:(HashTagCollection *)hashTagCollection sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID;
- (void)getUserForUserName:(NSString *)userName;
- (void)getTweetsForUser:(User *)user sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID;
- (void)getTweetsForConversationBetweenUserName:(NSString *)firstUserName andUserName:(NSString *)secondUserName withMaximumID:(TweetID)maxID;
- (void)retweet:(TweetID)tweetID;
- (void)createTweet:(NSString *)text inResponseToTweetID:(TweetID)replyingToTweetID;
- (void)getTweetsBySearch:(NSString *)searchTerm sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID;

@end
