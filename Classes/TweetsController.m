#import "TweetsController.h"
#import "TweetTableViewCell.h"
#import "Tweet.h"
#import "TweetTypeDetails.h"
#import "TweetController.h"
#import "RefreshManager.h"
#import "FavouritesManager.h"
#import "TweetComposerController.h"
#import "TwitterAccountManager.h"
#import "GANTracker.h"

@implementation TweetsController

@synthesize tweets, tweetTypeDetails, tweetIndexPathToShowUsersFor;

- (id)initWithTweetTypeDetails:(TweetTypeDetails *)newTweetTypeDetails{
	if(self == [super initWithNibName:nil bundle:nil]){
		tweetsManager = [[TweetsManager alloc] initWithTweetsManagerDelegate:self];
		self.tweetTypeDetails = newTweetTypeDetails;
		NSString *typeUrl = @"";
        if(newTweetTypeDetails.tweetType == TweetTypeStream) {
            self.title = self.tweetTypeDetails.stream.shortName;
            typeUrl = [NSString stringWithFormat:@"stream/%@", self.title];
        }
        else if(newTweetTypeDetails.tweetType == TweetTypeHashTag) {
            self.title = [NSString stringWithFormat:@"#%@",newTweetTypeDetails.hashTag];
            typeUrl = [NSString stringWithFormat:@"hashtag/%@", self.title];
        }
        else if(newTweetTypeDetails.tweetType == TweetTypeUser) {
            self.title = [self.tweetTypeDetails.user getFullNameOrUsername];
            typeUrl = [NSString stringWithFormat:@"user/%@", self.title];
        }
        else if(newTweetTypeDetails.tweetType == TweetTypeHashTagCollection) {
            self.title = self.tweetTypeDetails.hashTagCollection.shortName;
            typeUrl = [NSString stringWithFormat:@"hashtagcollection/%@", self.title];
        }
        else if(newTweetTypeDetails.tweetType == TweetTypeSearch) {
            self.title = self.tweetTypeDetails.searchTerm;
            typeUrl = [NSString stringWithFormat:@"search/%@", self.title];
        }
        retweetActionsIsDisabled = NO;
        
        NSError *error;
        NSString *url = [NSString stringWithFormat:@"/tweets/%@", typeUrl];
        if (![[GANTracker sharedTracker] trackPageview:url withError:&error]) {
            NSLog(@"Error tracking page using google analytics: %@", error);
        }
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tweets = [[NSMutableArray alloc] init];
	self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(!retweetActionsIsDisabled) {
        [self setUpLongPressGestureRecognition];
    }
	[self setUpRefreshEverythingButton];
	[self setUpMessageView];
    [self setUpNoTweetsFoundView];
    [self setUpNoTweetsFoundForUserView];
	[self loadInitialTweets];
}

- (void)setUpNoTweetsFoundView{
    noTweetsFoundView = [[UIView alloc] initWithFrame:CGRectMake(40, 150, 240, 50)];
    noTweetsFoundView.backgroundColor = [UIColor blackColor];
    noTweetsFoundView.hidden = YES;
    noTweetsFoundView.alpha = ALPHA_LEVEL;
    noTweetsFoundView.layer.cornerRadius = 10.0;
    UILabel *noTweetsFoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 50)];
    noTweetsFoundLabel.textAlignment = UITextAlignmentCenter;
    noTweetsFoundLabel.text = @"No Tweets Found";
    noTweetsFoundLabel.textColor = [UIColor whiteColor];
    noTweetsFoundLabel.backgroundColor = [UIColor clearColor];
    [noTweetsFoundView addSubview:noTweetsFoundLabel];
    [noTweetsFoundLabel release];
    [self.view addSubview:noTweetsFoundView];
}

- (void)setUpNoTweetsFoundForUserView{
    noTweetsFoundForUserView = [[UIView alloc] initWithFrame:CGRectMake(40, 120, 240, 140)];
    noTweetsFoundForUserView.backgroundColor = [UIColor blackColor];
    noTweetsFoundForUserView.hidden = YES;
    noTweetsFoundForUserView.alpha = ALPHA_LEVEL;
    noTweetsFoundForUserView.layer.cornerRadius = 10.0;
    UILabel *noTweetsFoundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 50)];
    noTweetsFoundLabel.textAlignment = UITextAlignmentCenter;
    noTweetsFoundLabel.text = @"No Tweets Found";
    noTweetsFoundLabel.textColor = [UIColor whiteColor];
    noTweetsFoundLabel.backgroundColor = [UIColor clearColor];
    [noTweetsFoundForUserView addSubview:noTweetsFoundLabel];
    [noTweetsFoundLabel release];
    UITextView *noTweetsFoundForUserTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 40, 220, 100)];
    noTweetsFoundForUserTextView.text = @"Note: Unauthenticated users can only view recent tweets in a users timeline. To view all tweets, login to your twitter account via the settings tab.";
    noTweetsFoundForUserTextView.userInteractionEnabled = NO;
    noTweetsFoundForUserTextView.textColor = [UIColor whiteColor];
    noTweetsFoundForUserTextView.backgroundColor = [UIColor clearColor];
    [noTweetsFoundForUserView addSubview:noTweetsFoundForUserTextView];
    [noTweetsFoundForUserTextView release];
    [self.view addSubview:noTweetsFoundForUserView];
}

- (void)showNoTweetsFoundView{
    BOOL isForSingleUser = (self.tweetTypeDetails.tweetType == TweetTypeStream && [self.tweetTypeDetails.stream.users count] == 1) || self.tweetTypeDetails.tweetType == TweetTypeUser;
	BOOL isAuthenticated = [[TwitterAccountManager shared] isAuthenticated];
	
    if(isForSingleUser && !isAuthenticated){
        noTweetsFoundForUserView.hidden = NO;
	}
    else{
        noTweetsFoundView.hidden = NO;
    }
}

- (void)hideNoTweetsFoundView{
    noTweetsFoundView.hidden = YES;
    noTweetsFoundForUserView.hidden = YES;
}

- (void)setUpLongPressGestureRecognition{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = LONG_PRESS_GESTURE_RECOGNITION_PRESS_DURATION;
    [self.tableView addGestureRecognizer:longPressGestureRecognizer];
    [longPressGestureRecognizer release];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(self.tweetIndexPathToShowUsersFor != nil) return;
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath != nil){
        self.tweetIndexPathToShowUsersFor = indexPath;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Reply", @"Quote", @"Retweet", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet release];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    Tweet *tweet = [self.tweets objectAtIndex:self.tweetIndexPathToShowUsersFor.row];
    self.tweetIndexPathToShowUsersFor = nil;
    if(buttonIndex != actionSheet.cancelButtonIndex){
        if([[TwitterAccountManager shared] isAuthenticated]){
            if(buttonIndex == 0 || buttonIndex == 1){
                TweetComposeType tweetComposeType = TweetComposeTypeReply;
                if(buttonIndex == 1) tweetComposeType = TweetComposeTypeQuote;
                TweetComposerController *tweetComposerController = [[TweetComposerController alloc] initWithTweet:tweet andTweetComposeType:tweetComposeType];
                [self.navigationController pushViewController:tweetComposerController animated:YES];
                [tweetComposerController release];
            }
            else if (buttonIndex == 2) {
                [messageView showLoadingMessage:@"Retweeting..."];
                [tweetsManager retweet:tweet.tweetId];
            }
        }
        else{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Not Authenticated" message:@"You must login to twitter first to use this feature. Click on the settings tab to login to your twitter account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}

- (void)setUpRefreshEverythingButton{
	UIBarButtonItem *refreshEverythingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshEverythingButtonClicked)];
	self.navigationItem.rightBarButtonItem = refreshEverythingButton;
    [refreshEverythingButton release];
}

- (void)setUpMessageView{
	messageView = [[MessageView alloc] init];
	[self.tableView addSubview:messageView];
}

- (void)loadInitialTweets{
    if(isLoading) return;
    isLoading = YES;
	[messageView showLoadingMessage];
	[self disableButtons];
	[self.tweets removeAllObjects];
	[self.tableView reloadData];
	insertNewTweetsAtIndex = 0;
	[self getTweetsSinceID:0 withMaximumID:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return [TweetTableViewCell cellHeightForTweet:[self.tweets objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TweetCell";
    
    TweetTableViewCell *cell = (TweetTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TweetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
	[cell setTweet:tweet andAlignment:TweetTableViewCellAlignmentLeft];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
	TweetController *tweetController = [[TweetController alloc] initWithTweet:tweet];
	[self.navigationController pushViewController:tweetController animated:YES];
	[tweetController release];
}

- (void)enableButtons{
	if(self.navigationItem.rightBarButtonItem){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    if(self.navigationItem.leftBarButtonItem){
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)disableButtons{
	if(self.navigationItem.rightBarButtonItem){
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    if(self.navigationItem.leftBarButtonItem){
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
}

- (void) refreshEverythingButtonClicked{
	[self loadInitialTweets];
}

- (void)getTweetsSinceID:(TweetID)sinceID withMaximumID:(TweetID)maxTweetID{
    [self hideNoTweetsFoundView];
	if(self.tweetTypeDetails.tweetType == TweetTypeStream) {
		[tweetsManager getTweetsForStream:self.tweetTypeDetails.stream sinceID:sinceID withMaximumID:maxTweetID];
	}
    else if(self.tweetTypeDetails.tweetType == TweetTypeHashTag) {
		[tweetsManager getTweetsForHashTag:self.tweetTypeDetails.hashTag sinceID:sinceID withMaximumID:maxTweetID];
	}
    else if(self.tweetTypeDetails.tweetType == TweetTypeUser) {
		[tweetsManager getTweetsForUser:self.tweetTypeDetails.user sinceID:sinceID withMaximumID:maxTweetID];
	}
    else if(self.tweetTypeDetails.tweetType == TweetTypeHashTagCollection) {
		[tweetsManager getTweetsForHashTagCollection:self.tweetTypeDetails.hashTagCollection sinceID:sinceID withMaximumID:maxTweetID];
	}
    else if(self.tweetTypeDetails.tweetType == TweetTypeFavourites) {
		[tweetsManager getTweetsForUserNames:[[FavouritesManager shared] getFavouriteUserNames] sinceID:sinceID withMaximumID:maxTweetID];
	}
    else if(self.tweetTypeDetails.tweetType == TweetTypeMyStream) {
		[tweetsManager getTweetsForUser:[[TwitterAccountManager shared] authenticatedUser] sinceID:sinceID withMaximumID:maxTweetID];
	}
    else if(self.tweetTypeDetails.tweetType == TweetTypeSearch) {
		[tweetsManager getTweetsBySearch:self.tweetTypeDetails.searchTerm sinceID:sinceID withMaximumID:maxTweetID];
	}
}

- (void)refresh{
    [self disableButtons];
	insertNewTweetsAtIndex  = 0;
	TweetID sinceTweetID = 0;
	if(self.tweets.count > 0) {
		Tweet *firstTweet = (Tweet *)[self.tweets objectAtIndex:0];
		sinceTweetID = firstTweet.tweetId;
	}
	[self getTweetsSinceID:sinceTweetID withMaximumID:0];
}

- (void)loadMore{
    [self disableButtons];
	insertNewTweetsAtIndex  = 0;
	TweetID maxTweetID = 0;
	if(self.tweets.count > 0) {
		Tweet *lastTweet = (Tweet *)[self.tweets lastObject];
		maxTweetID = lastTweet.tweetId - 1;
		insertNewTweetsAtIndex = self.tweets.count;
	}
	[self getTweetsSinceID:0 withMaximumID:maxTweetID];
}

- (void)tweetManagerDidReceiveTweets:(NSArray *)newTweets{
	[messageView hide];
	[self enableButtons];
	int i;
	for(i = 0; i < newTweets.count; i++){
		Tweet *newTweet = [newTweets objectAtIndex:i];
		[self.tweets insertObject:newTweet atIndex:insertNewTweetsAtIndex];
		insertNewTweetsAtIndex++;
	}
	insertNewTweetsAtIndex = 0;
	[self.tableView reloadData];
	[self stopLoading];
    if(self.tweets.count == 0){
        [self showNoTweetsFoundView];
    }
}

- (void)tweetManagerDidSuccessfullyReTweet{
    [messageView hide];
    [messageView showSuccessMessage:@"Retweeted successfully."];
}

- (void)tweetManagerRequestFailedWithError:(NSString *)error{
	[messageView hide];
	[self enableButtons];
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	[self stopLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if([[RefreshManager shared] tweetListScreenNeedsRefreshing]){
        [[RefreshManager shared] setTweetListScreenNeedsRefreshing:NO];
        [self loadInitialTweets];
    }
}

- (void)dealloc {
    [noTweetsFoundView release];
    [noTweetsFoundForUserView release];
    [tweetIndexPathToShowUsersFor release];
    tweetsManager.delegate = nil;
	[tweetsManager release];
	[messageView release];
	[tweetTypeDetails release];
	[tweets release];
    [super dealloc];
}


@end

