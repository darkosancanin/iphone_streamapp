#import "SettingsManager.h"

#define TWEET_LIST_FONT_SIZE_KEY @"TweetListFontSize"
#define TWEET_FONT_SIZE_KEY @"TweetFontSize"
#define SHOW_RETWEETS_KEY @"ShowRetweets"
#define DEFAULT_TWEET_FONT_SIZE 18
#define DEFAULT_TWEET_LIST_FONT_SIZE 14
#define DEFAULT_SHOW_RETWEETS_VALUE YES

@implementation SettingsManager

@synthesize tweetListFontSize, tweetFontSize, showRetweets;

- (id)init {
	if(self == [super init]){
        NSNumber *tweetListFontSizeNumber = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:TWEET_LIST_FONT_SIZE_KEY];
        if(tweetListFontSizeNumber != nil){
            tweetListFontSize = [tweetListFontSizeNumber intValue];
        }
        else{
            tweetListFontSize = DEFAULT_TWEET_LIST_FONT_SIZE;
        }
        
        NSNumber *tweetFontSizeNumber = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:TWEET_FONT_SIZE_KEY];
        if(tweetFontSizeNumber != nil){
            tweetFontSize = [tweetFontSizeNumber intValue];
        }
        else{
            tweetFontSize = DEFAULT_TWEET_FONT_SIZE;
        }
        
        NSNumber *showRetweetsNumber = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:SHOW_RETWEETS_KEY];
        if(showRetweetsNumber != nil){
            showRetweets = [showRetweetsNumber boolValue];
        }
        else{
            showRetweets = DEFAULT_SHOW_RETWEETS_VALUE;
        }
	}
	return self;
}

+ (SettingsManager *)shared
{
	static SettingsManager *sharedSingleton;
	@synchronized(self)
	{
		if (!sharedSingleton)
		{
			sharedSingleton = [[SettingsManager alloc] init];
		}
		return sharedSingleton;
	}
}

- (void)setShowRetweets:(BOOL)newShowRetweets{
    showRetweets = newShowRetweets;
    NSNumber *showRetweetsNumber = [NSNumber numberWithBool:newShowRetweets];
    [[NSUserDefaults standardUserDefaults] setObject:showRetweetsNumber forKey:SHOW_RETWEETS_KEY];
}

- (void)setTweetListFontSize:(int)newTweetListFontSize{
    tweetListFontSize = newTweetListFontSize;
    NSNumber *tweetListFontSizeNumber = [NSNumber numberWithInt:newTweetListFontSize];
    [[NSUserDefaults standardUserDefaults] setObject:tweetListFontSizeNumber forKey:TWEET_LIST_FONT_SIZE_KEY];
}

- (void)setTweetFontSize:(int)newTweetFontSize{
    tweetFontSize = newTweetFontSize;
    NSNumber *tweetFontSizeNumber = [NSNumber numberWithInt:newTweetFontSize];
    [[NSUserDefaults standardUserDefaults] setObject:tweetFontSizeNumber forKey:TWEET_FONT_SIZE_KEY];
}

- (void)resetAllSettings{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TWEET_LIST_FONT_SIZE_KEY];
    tweetListFontSize = DEFAULT_TWEET_LIST_FONT_SIZE;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TWEET_FONT_SIZE_KEY];
    tweetFontSize = DEFAULT_TWEET_FONT_SIZE;
}

- (void)dealloc{
    [super dealloc];
}

@end
