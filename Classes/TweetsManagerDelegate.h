#import <Foundation/Foundation.h>
#import "User.h"

@protocol TweetsManagerDelegate <NSObject>

@required
- (void)tweetManagerRequestFailedWithError:(NSString *)error;

@optional
- (void)tweetManagerDidReceiveTweets:(NSArray *)newTweets;
- (void)tweetManagerDidReceiveUser:(User *)theUser;
- (void)tweetManagerDidSuccessfullyReTweet;
- (void)tweetManagerDidSuccessfullyCreateTweet;

@required


@end
