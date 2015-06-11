#import "TwitterAccountManager.h"
#import "OAuthCore.h"
#import "RefreshManager.h"
#import "ApplicationSettings.h"

#define TOKEN_KEY @"Token"

@implementation TwitterAccountManager

@synthesize delegate, asiHttpRequest, twitterToken;

- (id)init{
	if(self == [super init]){
        NSData* twitterTokenData = [[NSUserDefaults standardUserDefaults] dataForKey: TOKEN_KEY];
        if (twitterTokenData != nil)
        {
            self.twitterToken = (TwitterToken *) [NSKeyedUnarchiver unarchiveObjectWithData: twitterTokenData];
        }
	}
	return self;
}

+ (TwitterAccountManager *)shared
{
	static TwitterAccountManager *sharedSingleton;
	@synchronized(self)
	{
		if (!sharedSingleton)
		{
			sharedSingleton = [[TwitterAccountManager alloc] init];
		}
		return sharedSingleton;
	}
}

- (void)signInWithUserName:(NSString *)theUserName andPassword:(NSString *)thePassword{
    [self.asiHttpRequest cancel];
    self.asiHttpRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"]];
    [self.asiHttpRequest setPostValue:@"client_auth" forKey:@"x_auth_mode"];
    [self.asiHttpRequest setPostValue:thePassword forKey:@"x_auth_password"];
    [self.asiHttpRequest setPostValue:theUserName forKey:@"x_auth_username"];
    [self.asiHttpRequest buildPostBody];
    NSString *header = OAuthorizationHeader([self.asiHttpRequest url], [self.asiHttpRequest requestMethod], [self.asiHttpRequest postBody], TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, @"", @"");
    [self.asiHttpRequest addRequestHeader:@"Authorization" value:header];
    [self.asiHttpRequest setDelegate:self];
	[self.asiHttpRequest startAsynchronous];
}

- (void)signOut{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: TOKEN_KEY];
    self.twitterToken = nil;
    [[RefreshManager shared] setMyStreamScreenNeedsRefreshing:YES];
    [self.delegate twitterAccountManagerDidSuccessfullySignOut];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *errorText = [[request error] localizedDescription];
    if ([errorText rangeOfString:@"Authentication needed"].location != NSNotFound) {
        [self.delegate twitterAccountManagerDidFailWithError:@"Authentication failed. Please try again."];
    }
	else{
        [self.delegate twitterAccountManagerDidFailWithError:[[request error] localizedDescription]];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    NSArray* pairs = [[request responseString] componentsSeparatedByString: @"&"];
	for (NSString* pair in pairs)
	{
		NSArray* nameValue = [pair componentsSeparatedByString: @"="];
		if ([nameValue count] == 2)
		{
			[parameters setValue: [self _formDecodeString: [nameValue objectAtIndex: 1]] forKey: [nameValue objectAtIndex: 0]];
		}
	}
	
    NSString *token = [parameters valueForKey: @"oauth_token"];
    NSString *secret = [parameters valueForKey: @"oauth_token_secret"];
    NSString *userName = [parameters valueForKey: @"screen_name"];
    
    if(token != nil && secret != nil && userName != nil){
        [[RefreshManager shared] setMyStreamScreenNeedsRefreshing:YES];
        TwitterToken *newToken = [[TwitterToken alloc] initWithToken:token secret:secret userName:userName];
        self.twitterToken = newToken;
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject: newToken] forKey:TOKEN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.delegate twitterAccountManagerDidSuccessfullySignIn];
    }
    else{
        [self.delegate twitterAccountManagerDidFailWithError:@"Authentication failed. Please try again."];
    }
}

- (NSString*) _formDecodeString: (NSString*) string
{
	NSString* decoded = (NSString*) CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef) string, NULL);
	return [decoded autorelease];
}

- (BOOL) isAuthenticated{
    return self.twitterToken != nil;
}

- (User *)authenticatedUser{
    return [[[User alloc] initWithUserName:self.twitterToken.userName] autorelease];
}

- (void)resetAllSettings{
    self.twitterToken = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: TOKEN_KEY];
}

- (void)dealloc{
    [twitterToken release];
    asiHttpRequest.delegate = nil;
	[asiHttpRequest release];
    self.delegate = nil;
    [super dealloc];
}

@end
