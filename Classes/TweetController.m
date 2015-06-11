#import "TweetController.h"
#import "TweetTableViewCell.h"
#import "Tweet.h"
#import "UserController.h"
#import "User.h"
#import "WebViewController.h"
#import "SearchController.h"
#import "TweetTypeDetails.h"
#import "RefreshManager.h"
#import "Global.h"
#import "SettingsManager.h"
#import "TweetComposerController.h"
#import "TwitterAccountManager.h"

@implementation TweetController

@synthesize tweet, conversationTweets, textWebView;

- (id)initWithTweet:(Tweet *)theTweet{
	if(self == [super initWithNibName:nil bundle:nil]){
		self.tweet = theTweet;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tweetsManager = [[TweetsManager alloc] initWithTweetsManagerDelegate:self];
    [self setUpMessageView];
	[self setUpUserInfoHeaderView];
	[self setUpTextWebView];
}

- (void)setUpMessageView{
	messageView = [[MessageView alloc] init];
    [self.view addSubview:messageView];
}

- (void)setUpActionButton{
	UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked)];
    self.navigationItem.rightBarButtonItem = actionButton;
    [actionButton release];
}

- (void)actionButtonClicked{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Reply", @"Quote", @"Retweet", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != actionSheet.cancelButtonIndex){
        if([[TwitterAccountManager shared] isAuthenticated]){
            if(buttonIndex == 0 || buttonIndex == 1){
                TweetComposeType tweetComposeType = TweetComposeTypeReply;
                if(buttonIndex == 1) tweetComposeType = TweetComposeTypeQuote;
                    TweetComposerController *tweetComposerController = [[TweetComposerController alloc] initWithTweet:self.tweet andTweetComposeType:tweetComposeType];
                [self.navigationController pushViewController:tweetComposerController animated:YES];
                [tweetComposerController release];
            }
            else if (buttonIndex == 2) {
                [messageView showLoadingMessage:@"Retweeting..."];
                [tweetsManager retweet:self.tweet.tweetId];
            }
        }
        else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Not Authenticated" message:@"You must login to twitter first to use this feature. Click on the settings tab to login to your twitter account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}

- (void)setUpTextWebView{
    if(self.textWebView){
        [self.textWebView removeFromSuperview];
    }
	self.textWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(10, 80, 300, 10)] autorelease];
	self.textWebView.delegate = self;
	self.textWebView.dataDetectorTypes = UIDataDetectorTypeLink;
	[[self.textWebView.subviews objectAtIndex:0] setScrollEnabled:NO];
	[[self.textWebView.subviews objectAtIndex:0] setBounces:NO];
	self.textWebView.backgroundColor = [UIColor clearColor];
	self.textWebView.opaque = NO;
    SettingsManager *settingsManager = [SettingsManager shared];
	NSString *html = [NSString stringWithFormat:@" \
					  <html> \
					  <head> \
					  <style type=\"text/css\"> \
					  body {font-family: \"helvetica\"; font-size: %i; color:#FFFFFF; margin: 0; padding: 0; } \
					  .top { background-image: url(top_bubble.png); background-repeat:no-repeat; height:23; width:300; opacity:%f; } \
					  .middle { background-image: url(middle_bubble.png); background-repeat:repeat-y; width:300; opacity:%f; } \
					  .date { padding:10px 13px 0px 13px; font-size:12; } \
					  .text { padding:0px 13px 0px 13px; } \
					  .bottom { background-image: url(bottom_bubble.png); background-repeat:no-repeat; height:10; width:300; opacity:%f; } \
					  a:link, a:visited, a:active { color: #FFFFFF; font-size:%i; text-decoration:none; } \
					  </style> \
					  <body> \
					  <div class=\"top\"></div> \
					  <div class=\"middle\"> \
					  <div class=\"text\"> \
                      <script type=\"text/javascript\"> \
                      var text = \"%@\"; \
                      document.writeln(text.replace(/@([1-9a-zA-Z_]+)/g,\"<a href='local://$1' style='-webkit-touch-callout:none;'>@$1</a>\").replace(/#([^\\s#@]*)/g,\"<a href='local://#$1' style='-webkit-touch-callout:none;'>#$1</a>\")); \
                      </script> \
					  </div> \
					  <div class=\"date\"> \
					  %@ \
					  </div> \
					  </div> \
					  <div class=\"bottom\"></div> \
					  </body> \
					  </head> \
					  </html> \
					  ", settingsManager.tweetFontSize, ALPHA_LEVEL, ALPHA_LEVEL, ALPHA_LEVEL, settingsManager.tweetFontSize, [[self.tweet.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""], [self.tweet createdDateLongFormat]];
	NSURL *baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
	[self.textWebView loadHTMLString:html baseURL:baseUrl];
	[self.tableView insertSubview:self.textWebView atIndex:0];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	CGFloat htmlHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"] floatValue] + 10;
	webView.frame = CGRectMake(webView.frame.origin.x, -htmlHeight, webView.frame.size.width, htmlHeight);
	userInfoHeaderView.frame = CGRectMake(userInfoHeaderView.frame.origin.x, -(userInfoHeaderView.frame.size.height + htmlHeight), userInfoHeaderView.frame.size.width, userInfoHeaderView.frame.size.height);
	self.tableView.contentInset = UIEdgeInsetsMake(userInfoHeaderView.frame.size.height + htmlHeight,0,0,0);
	self.tableView.contentOffset = CGPointMake(0, -(userInfoHeaderView.frame.size.height + htmlHeight));
    
    if(self.tweet.toUserName != nil && self.tweet.toUserName.length > 2){
        [self startLoadingConversationTweets];
    }
    
    [self setUpActionButton];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if([request.URL.scheme isEqualToString:@"file"]){
        return YES;
    }
    else if([request.URL.scheme isEqualToString:@"local"]){
        NSString *twitterLink = [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"local://" withString:@""];
        if([twitterLink hasPrefix:@"#"]){
            SearchController *searchController = [[SearchController alloc] initWithSearchTerm:twitterLink];
            [self.navigationController pushViewController:searchController animated:YES];
            [searchController release];
            return NO;   
        }
        else{
            User *user = [[User alloc] initWithUserName:twitterLink];
            UserController *userController = [[UserController alloc] initWithAUser:user];
            [user release];
            [self.navigationController pushViewController:userController animated:YES];
            [userController release];
            return NO;   
        }
    }
    WebViewController *webViewController = [[WebViewController alloc] initWithUrlRequest:request];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
    return NO;
}

- (void)setUpUserInfoHeaderView{
	userInfoHeaderView = [[UserInfoHeaderView alloc] initWithFullName:self.tweet.fullName andUserName:self.tweet.userName andProfileImageUrl:self.tweet.profileImageUrl andDisplayAccessoryArrow:YES];
	[userInfoHeaderView addTarget:self action:@selector(userInfoHeaderViewClicked) forControlEvents:UIControlEventTouchUpInside];	
	[self.tableView addSubview:userInfoHeaderView];
}

- (void)userInfoHeaderViewClicked{
	User *user = [[User alloc] initWithTweet:self.tweet];
	UserController *userController = [[UserController alloc] initWithAUser:user];
	[user release];
	[self.navigationController pushViewController:userController animated:YES];
	[userController release];
}

- (void)startLoadingConversationTweets{
    messageView.frame = CGRectMake(messageView.frame.origin.x, self.textWebView.frame.origin.y + self.textWebView.frame.size.height + 10, messageView.frame.size.width, messageView.frame.size.height);
    [messageView showLoadingMessage:@"Loading conversation..."];
    [tweetsManager getTweetsForConversationBetweenUserName:self.tweet.userName andUserName:self.tweet.toUserName withMaximumID:self.tweet.tweetId - 1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return conversationTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"TweetCell";
	TweetTableViewCell *cell = (TweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[TweetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
    Tweet *currentTweet = [self.conversationTweets objectAtIndex:indexPath.row];
    TweetTableViewCellAlignment cellAlignment;
    if([self.tweet.userName isEqualToString:currentTweet.userName]){
        cellAlignment = TweetTableViewCellAlignmentLeft;
    }
    else{
        cellAlignment = TweetTableViewCellAlignmentRight;
    }
	[cell setTweet:currentTweet andAlignment:cellAlignment];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [TweetTableViewCell cellHeightForTweet:[self.conversationTweets objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Tweet *conversationTweet = [self.conversationTweets objectAtIndex:indexPath.row];
	TweetController *tweetController = [[TweetController alloc] initWithTweet:conversationTweet];
	[self.navigationController pushViewController:tweetController animated:YES];
	[tweetController release];
}

- (void)tweetManagerDidReceiveTweets:(NSArray *)newTweets{
    [messageView hide];
    self.conversationTweets = newTweets;
    [self.tableView reloadData];
}

- (void)tweetManagerDidSuccessfullyReTweet{
    [messageView hide];
    [messageView showSuccessMessage:@"Retweeted successfully."];
}

- (void)tweetManagerRequestFailedWithError:(NSString *)error{
    [messageView hide];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if([[RefreshManager shared] tweetScreenNeedsRefreshing]){
        [[RefreshManager shared] setTweetScreenNeedsRefreshing:NO];
        [self setUpTextWebView];
    }
    else{
        if([[RefreshManager shared] tweetListScreenNeedsRefreshing]){
            [[RefreshManager shared] setTweetListScreenNeedsRefreshing:NO];
            [self.tableView reloadData];
        }
    }
}

- (void)dealloc {
    [textWebView release];
    [messageView release];
    [conversationTweets release];
    [tweetsManager release];
	[userInfoHeaderView release];
	[tweet release];
    [super dealloc];
}

@end

