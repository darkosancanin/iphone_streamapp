#import "TweetsManager.h"
#import "SettingsManager.h"
#import "Tweet.h"
#import "Stream.h"
#import "NSDictionary_JSONExtensions.h"
#import "TweetsManagerDelegate.h"
#import "ApplicationDataManager.h"
#import "ApplicationSettings.h"
#import "Global.h"
#import "TwitterAccountManager.h"
#import "NSString+UrlEncode.h"

#define kTwitterApiDateFormat @"EEE MMM dd HH:mm:ss ZZZ yyyy"
#define kTwitterSearchDateFormat @"EEE, dd MMM yyyy HH:mm:ss ZZZ"

@implementation TweetsManager

@synthesize delegate, asiHttpRequest;

- (id)initWithTweetsManagerDelegate:(id<TweetsManagerDelegate>)tweetsManagerDelegate {
	if(self == [super init]){
		self.delegate = tweetsManagerDelegate;
		self.asiHttpRequest = nil;
	}
	return self;
}

- (void)getUserForUserName:(NSString *)userName{
    #if USE_TEMP_DATA
	[self returnUserTestData]; return;
    #endif
    
    NSMutableString *url = [[NSMutableString alloc] initWithFormat:@"http://api.twitter.com/1/users/show/%@.json", userName];
    if([[SettingsManager shared] showRetweets]){
        [url appendString:@"?include_rts=true"];
    }
    [self sendRequestToTwitterToUrl:url andSinceID:0 andMaximumID:0 andTwitterResponseType:TwitterResponseTypeUser andUserInfo:nil];
}

- (void)getTweetsBySearch:(NSString *)searchTerm sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID{
    #if USE_TEMP_DATA
	[self returnTweetsTestData]; return;
    #endif
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:@"http://search.twitter.com/search.json?result_type=recent&rpp=100&q="];
    [url appendString:[searchTerm urlEncoded]];
    if([[SettingsManager shared] showRetweets]){
        [url appendString:@"&include_rts=true"];
    }
    [self sendRequestToTwitterToUrl:url andSinceID:sinceID andMaximumID:maxID andTwitterResponseType:TwitterResponseTypeTweetSearch andUserInfo:nil];
}

- (void)getTweetsForUser:(User *)user sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID{
    #if USE_TEMP_DATA
	[self returnTweetsTestData]; return;
    #endif
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name="];
    [url appendString:user.userName];
    if([[SettingsManager shared] showRetweets]){
        [url appendString:@"&include_rts=true"];
    }
    [self sendRequestToTwitterToUrl:url andSinceID:sinceID andMaximumID:maxID andTwitterResponseType:TwitterResponseTypeUserTimeLine andUserInfo:nil];
}

- (void)getTweetsForConversationBetweenUserName:(NSString *)firstUserName andUserName:(NSString *)secondUserName withMaximumID:(TweetID)maxID{
    #if USE_TEMP_DATA
	[self returnTweetsTestData]; return;
    #endif
	
	NSMutableString *url = [[NSMutableString alloc] initWithString:@"http://search.twitter.com/search.json?result_type=recent&rpp=100&q=from%3A"];
	[url appendString:firstUserName];
    [url appendString:@"+OR+from%3A"];
    [url appendString:secondUserName];
    if([[SettingsManager shared] showRetweets]){
        [url appendString:@"&include_rts=true"];
    }
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:firstUserName, @"first_username", secondUserName, @"second_username", nil];
	[self sendRequestToTwitterToUrl:url andSinceID:0 andMaximumID:maxID andTwitterResponseType:TwitterResponseTypeTweetConversationSearch andUserInfo:userInfo];
    [userInfo release];
}

- (void)getTweetsForUserNames:(NSArray *)userNames sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID{
    #if USE_TEMP_DATA
	[self returnTweetsTestData]; return;
    #endif
	
    if([userNames count] == 1 && [[TwitterAccountManager shared] isAuthenticated]){
        User *user = [[User alloc] initWithUserName:[userNames objectAtIndex:0]];
        [self getTweetsForUser:user sinceID:sinceID withMaximumID:maxID];
        [user release];
        return;
    }
    
	NSMutableString *url = [[NSMutableString alloc] initWithString:@"http://search.twitter.com/search.json?result_type=recent&rpp=20&q="];
	BOOL isFirstUsername = YES;
	for (NSString *userName in userNames) {
        if([userName length] == 0) continue;
		if(!isFirstUsername) [url appendString:@"+OR+"];
		[url appendString:@"from%3A"];
		[url appendString:userName];
		isFirstUsername = NO;
	}
    if([[SettingsManager shared] showRetweets]){
        [url appendString:@"&include_rts=true"];
    }
	[self sendRequestToTwitterToUrl:url andSinceID:sinceID andMaximumID:maxID andTwitterResponseType:TwitterResponseTypeTweetSearch andUserInfo:nil];
}

- (void)getTweetsForStream:(Stream *)stream sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID{
	#if USE_TEMP_DATA
	[self returnTweetsTestData]; return;
	#endif
    
    if([stream.users count] == 1 && [[TwitterAccountManager shared] isAuthenticated]){
        [self getTweetsForUser:[stream.users objectAtIndex:0] sinceID:sinceID withMaximumID:maxID];
        return;
    }
	
	NSMutableString *url = [[NSMutableString alloc] initWithString:@"http://search.twitter.com/search.json?result_type=recent&rpp=20&q="];
	BOOL isFirstUsername = YES;
	for (User *user in stream.users) {
        if([user.userName length] == 0) continue;
		if(!isFirstUsername) [url appendString:@"+OR+"];
		[url appendString:@"from%3A"];
		[url appendString:user.userName];
		isFirstUsername = NO;
	}
    if([[SettingsManager shared] showRetweets]){
        [url appendString:@"&include_rts=true"];
    }
	[self sendRequestToTwitterToUrl:url andSinceID:sinceID andMaximumID:maxID andTwitterResponseType:TwitterResponseTypeTweetSearch andUserInfo:nil];
}

- (void)getTweetsForHashTagCollection:(HashTagCollection *)hashTagCollection sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID{
    #if USE_TEMP_DATA
	[self returnTweetsTestData]; return;
    #endif
	
	NSMutableString *url = [[NSMutableString alloc] initWithString:@"http://search.twitter.com/search.json?result_type=recent&rpp=20&q="];
	BOOL isFirstHashTag = YES;
	for (NSString *hashTag in hashTagCollection.hashTags) {
		if(!isFirstHashTag) [url appendString:@"+OR+"];
		[url appendString:@"%23"];
		[url appendString:hashTag];
		isFirstHashTag = NO;
	}
    if([[SettingsManager shared] showRetweets]){
        [url appendString:@"&include_rts=true"];
    }
	[self sendRequestToTwitterToUrl:url andSinceID:sinceID andMaximumID:maxID andTwitterResponseType:TwitterResponseTypeTweetSearch andUserInfo:nil];
}

- (void)getTweetsForHashTag:(NSString *)hashTag sinceID:(TweetID)sinceID withMaximumID:(TweetID)maxID{
    #if USE_TEMP_DATA
	[self returnTweetsTestData]; return;
    #endif
	
	NSMutableString *url = [[NSMutableString alloc] initWithString:@"http://search.twitter.com/search.json?result_type=recent&rpp=20&q=%23"];
	[url appendString:hashTag];
    if([[SettingsManager shared] showRetweets]){
        [url appendString:@"&include_rts=true"];
    }
	[self sendRequestToTwitterToUrl:url andSinceID:sinceID andMaximumID:maxID andTwitterResponseType:TwitterResponseTypeTweetSearch andUserInfo:nil];
}

- (void)retweet:(TweetID)tweetID{
    [self.asiHttpRequest cancel];
	self.asiHttpRequest = nil;
	currentTwitterResponseType = TwitterResponseTypeRetweet;
    NSString *url = [NSString stringWithFormat:@"http://api.twitter.com/1/statuses/retweet/%llu.json", tweetID];
	NSURL *nsUrl = [NSURL URLWithString:url];
	self.asiHttpRequest = [ASIHTTPRequest requestWithURL:nsUrl];
    self.asiHttpRequest.requestMethod = @"POST";
    [self setUpRequestAndStartAsynchronousRequest];
}

- (void)createTweet:(NSString *)text inResponseToTweetID:(TweetID)replyingToTweetID{
    [self.asiHttpRequest cancel];
	self.asiHttpRequest = nil;
	currentTwitterResponseType = TwitterResponseTypeCreateTweet;
    NSMutableString *url = [[NSMutableString alloc] initWithString:@"http://api.twitter.com/1/statuses/update.json?status="];
    [url appendString:[text urlEncoded]];
    if(replyingToTweetID > 0){
		[url appendString:[NSString stringWithFormat:@"&in_reply_to_status_id=%llu", replyingToTweetID]];
	}
	NSURL *nsUrl = [NSURL URLWithString:url];
	self.asiHttpRequest = [ASIHTTPRequest requestWithURL:nsUrl];
    self.asiHttpRequest.requestMethod = @"POST";
    [self setUpRequestAndStartAsynchronousRequest];
}

- (void)sendRequestToTwitterToUrl:(NSMutableString *)url andSinceID:(TweetID)sinceID andMaximumID:(TweetID)maxID andTwitterResponseType:(TwitterResponseType)twitterResponseType andUserInfo:(NSDictionary *)userInfo{
	[self.asiHttpRequest cancel];
	self.asiHttpRequest = nil;
	currentTwitterResponseType = twitterResponseType;
	
	if(sinceID > 0){
		[url appendString:[NSString stringWithFormat:@"&since_id=%llu", sinceID]];
	}
	if(maxID > 0){
		[url appendString:[NSString stringWithFormat:@"&max_id=%llu", maxID]];
	}
	
	NSURL *nsUrl = [NSURL URLWithString:url];
	self.asiHttpRequest = [ASIHTTPRequest requestWithURL:nsUrl];
    self.asiHttpRequest.requestMethod = @"GET";
    self.asiHttpRequest.userInfo = userInfo;
    [self setUpRequestAndStartAsynchronousRequest];
}

- (void)setUpRequestAndStartAsynchronousRequest{
    TwitterAccountManager *twitterAccountManager = [TwitterAccountManager shared];
    if([twitterAccountManager isAuthenticated]){
        NSString *header = OAuthorizationHeader([self.asiHttpRequest url], [self.asiHttpRequest requestMethod], [self.asiHttpRequest postBody], TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, twitterAccountManager.twitterToken.token, twitterAccountManager.twitterToken.secret);
        [self.asiHttpRequest addRequestHeader:@"Authorization" value:header];
    }
    self.asiHttpRequest.delegate = self;
	[self.asiHttpRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString *responseString = [request responseString];
	NSError *error;
	NSDictionary *responseDictionary = (NSDictionary *)[NSDictionary dictionaryWithJSONString:responseString error:&error];
	if(!responseDictionary){
		[delegate tweetManagerRequestFailedWithError:[error localizedDescription]];
		return;
	}
	if([request responseStatusCode] >= 400){
		BOOL errorHandled = NO;
        if([responseDictionary objectForKey:@"error"]){
            NSString *errorText = [responseDictionary objectForKey:@"error"];
            errorHandled = YES;
            if ([errorText rangeOfString:@"Rate limit exceeded"].location != NSNotFound) {
                [delegate tweetManagerRequestFailedWithError:@"Twitter rate limit exceeded.\n\nNote: Logging in to your twitter account via the settings tab will increase the twitter rate limit."];
            }
            else{
                [delegate tweetManagerRequestFailedWithError:[responseDictionary objectForKey:@"error"]];
            }
		}
        else if([responseDictionary objectForKey:@"errors"]){
            NSString *errorsText = [responseDictionary objectForKey:@"errors"];
            if ([errorsText rangeOfString:@"sharing is not permissable for this status"].location != NSNotFound) {
                errorHandled = YES;
                [delegate tweetManagerRequestFailedWithError:@"Sharing is not allowed for this status."];
            }
		}
		if(!errorHandled) {
			[delegate tweetManagerRequestFailedWithError:@"Request failed. Please try again."];
		}

		return;
	}
	
	if(currentTwitterResponseType == TwitterResponseTypeTweetSearch){
		[self parseTweetSearchResults:responseDictionary];
	}
    else if(currentTwitterResponseType == TwitterResponseTypeUser){
		[self parseUserDetails:responseDictionary];
	}
    else if(currentTwitterResponseType == TwitterResponseTypeTweetConversationSearch){
		[self parseTweetConversationSearchResults:responseDictionary];
	}
    else if(currentTwitterResponseType == TwitterResponseTypeUserTimeLine){
		[self parseUserTimeLine:responseDictionary];
	}
    else if(currentTwitterResponseType == TwitterResponseTypeRetweet){
		[self.delegate tweetManagerDidSuccessfullyReTweet];
	}
    else if(currentTwitterResponseType == TwitterResponseTypeCreateTweet){
		[self.delegate tweetManagerDidSuccessfullyCreateTweet];
	}
}

- (void)parseUserTimeLine:(NSDictionary *)responseDictionary{
	NSDictionary *fullNameLookup = [[ApplicationDataManager shared] userFullNameLookup];
	NSMutableArray *tweets = [[NSMutableArray alloc] init];
	for ( NSDictionary *statusDictionary in responseDictionary )
	{
		NSString *text = [statusDictionary objectForKey:@"text"];
		NSNumber *numericTweetID = (NSNumber *)[statusDictionary objectForKey:@"id"];
		TweetID tweetID = [numericTweetID unsignedLongLongValue];
        NSDictionary *userDictionary = (NSDictionary *)[statusDictionary objectForKey:@"user"];
		NSString *userName = [userDictionary objectForKey:@"screen_name"];
		NSString *fullName = [fullNameLookup objectForKey:[userName lowercaseString]];
		NSString *profileImageUrl = [userDictionary objectForKey:@"profile_image_url"];
		NSString *dateCreated = [statusDictionary objectForKey:@"created_at"];
        NSString *toUserName = nil;
        if ((NSNull *)[statusDictionary objectForKey:@"in_reply_to_screen_name"] != [NSNull null]) { 
            toUserName = [statusDictionary objectForKey:@"in_reply_to_screen_name"];
        }
		Tweet *tweet = [[Tweet alloc] initWithTweetId:tweetID andFullName:fullName andUserName:userName andProfileImageUrl:profileImageUrl andText:text andDateCreated:dateCreated andDateCreatedFormat:kTwitterApiDateFormat andToUserName:toUserName];
		[tweets addObject:tweet];
		[tweet release];
	}

	[self.delegate tweetManagerDidReceiveTweets:tweets];
    [tweets release];
}

- (void)parseUserDetails:(NSDictionary *)responseDictionary{
    NSString *location = [responseDictionary objectForKey:@"location"];
    if([location isEqual:[NSNull null]]) location = nil;
    NSString *profileImageUrl = [responseDictionary objectForKey:@"profile_image_url"];
    NSString *fullName = [responseDictionary objectForKey:@"name"];
    NSString *bio = [responseDictionary objectForKey:@"description"];
    if([bio isEqual:[NSNull null]]) bio = nil;
    NSString *userName = [responseDictionary objectForKey:@"screen_name"];
    NSString *url = [responseDictionary objectForKey:@"url"];
    if([url isEqual:[NSNull null]]) url = nil;
    BOOL verified = [[responseDictionary objectForKey:@"verified"] boolValue];
    int numberOfFollowers = [[responseDictionary objectForKey:@"followers_count"] intValue];
    int numberOfTweets = [[responseDictionary objectForKey:@"statuses_count"] intValue];
    User *user = [[User alloc] initWithFullName:fullName andUserName:userName andProfileImageUrl:profileImageUrl andLocation:location andBio:bio andVerified:verified andNumberOfTweets:numberOfTweets andNumberOfFollowers:numberOfFollowers andUrl:url];
	[self.delegate tweetManagerDidReceiveUser:user];
	[user release];
}

- (void)parseTweetConversationSearchResults:(NSDictionary *)responseDictionary{
    NSString *firstUsername = [[self.asiHttpRequest.userInfo objectForKey:@"first_username"] lowercaseString];
    NSString *secondUsername = [[self.asiHttpRequest.userInfo objectForKey:@"second_username"] lowercaseString];
    NSArray *tweets = [self getParsedTweetsSearchResults:responseDictionary];
    NSMutableArray *conversationTweets = [[NSMutableArray alloc] init];
    for (Tweet *tweet in tweets) {
        if(([[tweet.userName lowercaseString] isEqualToString:firstUsername] && [[tweet.toUserName lowercaseString] isEqualToString:secondUsername]) || 
           ([[tweet.userName lowercaseString] isEqualToString:secondUsername] && [[tweet.toUserName lowercaseString] isEqualToString:firstUsername])) {
            [conversationTweets addObject:tweet];
            }
    }
	[self.delegate tweetManagerDidReceiveTweets:conversationTweets];
    [conversationTweets release];
}

- (void)parseTweetSearchResults:(NSDictionary *)responseDictionary{
	NSArray *tweets = [self getParsedTweetsSearchResults:responseDictionary];
	[self.delegate tweetManagerDidReceiveTweets:tweets];
}

- (NSArray *)getParsedTweetsSearchResults:(NSDictionary *)responseDictionary{
	NSDictionary *fullNameLookup = [[ApplicationDataManager shared] userFullNameLookup];
	NSMutableArray *tweets = [[NSMutableArray alloc] init];
	NSDictionary *statusesDictionary = [responseDictionary objectForKey:@"results"];
	for ( NSDictionary *statusDictionary in statusesDictionary )
	{
		NSString *text = [statusDictionary objectForKey:@"text"];
		NSNumber *numericTweetID = (NSNumber *)[statusDictionary objectForKey:@"id"];
		TweetID tweetID = [numericTweetID unsignedLongLongValue];
		NSString *userName = [statusDictionary objectForKey:@"from_user"];
		NSString *fullName = [fullNameLookup objectForKey:[userName lowercaseString]];
		NSString *profileImageUrl = [statusDictionary objectForKey:@"profile_image_url"];
		NSString *dateCreated = [statusDictionary objectForKey:@"created_at"];
        NSString *toUserName = nil;
        if ((NSNull *)[statusDictionary objectForKey:@"to_user"] != [NSNull null]) { 
            toUserName = [statusDictionary objectForKey:@"to_user"];
        }
		Tweet *tweet = [[Tweet alloc] initWithTweetId:tweetID andFullName:fullName andUserName:userName andProfileImageUrl:profileImageUrl andText:text andDateCreated:dateCreated andDateCreatedFormat:kTwitterSearchDateFormat andToUserName:toUserName];
		[tweets addObject:tweet];
		[tweet release];
	}
	return [tweets autorelease];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	[delegate tweetManagerRequestFailedWithError:[error localizedDescription]];
}

- (void)returnTweetsTestData{
	NSMutableArray *tweets = [[NSMutableArray alloc] init];
    [tweets addObject:[[Tweet alloc] initWithTweetId:1 andFullName:@"Allan Houston" andUserName:@"ALLAN_HOUSTON" andProfileImageUrl:@"http://a0.twimg.com/profile_images/1288315644/lQJOX_normal.jpg" andText:@"So thankful for everyone coming out to our house for the AHLegacyFoundation benefit! @MSGTina did a wonderful job hosting! Checkout http://www.nba.com #NYKnicks" andDateCreated:@"Sat, 09 Apr 2011 12:10:19 +0000" andDateCreatedFormat:kTwitterSearchDateFormat andToUserName:@"carmeloanthony"]];
	[tweets addObject:[[Tweet alloc] initWithTweetId:2 andFullName:@"Charles Oakley" andUserName:@"CharlesOakley34" andProfileImageUrl:@"http://a2.twimg.com/profile_images/824213003/C.Oak_in_Miami__0310_cropped_normal.JPG" andText:@"@MikeHillESPN haha. Make sure u hit me up" andDateCreated:@"Thu, 07 Apr 2011 05:13:19 +0000" andDateCreatedFormat:kTwitterSearchDateFormat andToUserName:nil]];
	[tweets addObject:[[Tweet alloc] initWithTweetId:3 andFullName:@"Amar'e Stoudemire" andUserName:@"Amareisreal" andProfileImageUrl:@"http://a1.twimg.com/profile_images/1246226918/Amareisreal_normal.jpg" andText:@"Bringing @thenyknicks swag to @sesamestreet. Check out Grover's warmups. http://twitpic.com/4fgrlq" andDateCreated:@"Mon, 02 Jun 2011 05:19:19 +0000" andDateCreatedFormat:kTwitterSearchDateFormat andToUserName:nil]];
	[tweets addObject:[[Tweet alloc] initWithTweetId:4 andFullName:@"Carmelo Anthony" andUserName:@"CarmeloAnthony" andProfileImageUrl:@"http://a2.twimg.com/profile_images/1252531937/image_normal.jpg" andText:@"Carmelo's New Billboard (3/29) http://fb.me/Oeb31exH" andDateCreated:@"Thu, 07 Apr 2011 05:13:19 +0000" andDateCreatedFormat:kTwitterSearchDateFormat andToUserName:nil]];
	[tweets addObject:[[Tweet alloc] initWithTweetId:5 andFullName:@"Landry Fields" andUserName:@"landryfields" andProfileImageUrl:@"http://a0.twimg.com/profile_images/1289360623/613x459_normal.jpg" andText:@"By looking at this photo, I'm willing to bet everyone knows what I am about to do next.. http://twitpic.com/4fefb9" andDateCreated:@"Thu, 07 Apr 2011 05:13:19 +0000" andDateCreatedFormat:kTwitterSearchDateFormat andToUserName:nil]];
	[tweets addObject:[[Tweet alloc] initWithTweetId:3 andFullName:@"Amar'e Stoudemire" andUserName:@"Amareisreal" andProfileImageUrl:@"http://a1.twimg.com/profile_images/1246226918/Amareisreal_normal.jpg" andText:@"About to film @sesamestreet with @carmeloanthony. Get ready Grover! http://twitpic.com/4fgi6j" andDateCreated:@"Wed, 01 Apr 2011 05:13:19 +0000" andDateCreatedFormat:kTwitterSearchDateFormat andToUserName:nil]];
	[tweets addObject:[[Tweet alloc] initWithTweetId:5 andFullName:@"Landry Fields" andUserName:@"landryfields" andProfileImageUrl:@"http://a0.twimg.com/profile_images/1289360623/613x459_normal.jpg" andText:@"One person with courage is a majority." andDateCreated:@"Thu, 07 Apr 2011 01:53:44 +0000" andDateCreatedFormat:kTwitterSearchDateFormat andToUserName:nil]];
	[tweets addObject:[[Tweet alloc] initWithTweetId:4 andFullName:@"Carmelo Anthony" andUserName:@"CarmeloAnthony" andProfileImageUrl:@"http://a2.twimg.com/profile_images/1252531937/image_normal.jpg" andText:@"A few pics from the crazy week that was... All Star 2011 http://say.ly/lFzaK9" andDateCreated:@"Fri, 08 Apr 2011 05:13:19 +0000" andDateCreatedFormat:kTwitterSearchDateFormat andToUserName:nil]];
	[delegate tweetManagerDidReceiveTweets:[tweets autorelease]];
}

- (void)returnUserTestData{
    User *user = [[User alloc] initWithFullName:@"Carmelo Anthony" andUserName:@"carmeloanthony" andProfileImageUrl:@"http://a2.twimg.com/profile_images/1252531937/image_normal.jpg" andLocation:@"Worldwide" andBio:@"Official Page of Carmelo Anthony of the New York Knicks" andVerified:YES andNumberOfTweets:1204 andNumberOfFollowers:867602 andUrl:@"http://www.thisismelo.com"];
    [delegate tweetManagerDidReceiveUser:[user autorelease]];
}

- (void)dealloc {
    asiHttpRequest.delegate = nil;
	[asiHttpRequest release];
    [super dealloc];
}

@end
