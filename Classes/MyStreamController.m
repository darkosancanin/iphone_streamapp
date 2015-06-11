#import <QuartzCore/QuartzCore.h>
#import "MyStreamController.h"
#import "TweetTypeDetails.h"
#import "TweetsManager.h"
#import "RefreshManager.h"
#import "TwitterAccountManager.h"
#import "TweetComposerController.h"
#import "Global.h"

@implementation MyStreamController

@synthesize notAuthenticatedMessageView;

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self == [super initWithCoder:aDecoder]){
        tweetsManager = [[TweetsManager alloc] initWithTweetsManagerDelegate:self];
        self.tweetTypeDetails = [[TweetTypeDetails alloc] initAsMyStream];
        self.title = @"My Stream";
        retweetActionsIsDisabled = YES;
    }
	return self;
}

- (void)viewDidLoad {
    [self setUpComposeButton];
    [super viewDidLoad];
}

- (void)setUpComposeButton{
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonClicked)];
    self.navigationItem.leftBarButtonItem = composeButton;
    [composeButton release];
}

- (void)composeButtonClicked{
    if([[TwitterAccountManager shared] isAuthenticated]){
        TweetComposerController *tweetComposerController = [[TweetComposerController alloc] init];
        [self.navigationController pushViewController:tweetComposerController animated:YES];
        [tweetComposerController release];
    }
    else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Not Authenticated" message:@"You must login to twitter first to use this feature. Click on the settings tab to login to your twitter account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (void)loadInitialTweets{
    if([[TwitterAccountManager shared] isAuthenticated]){
        self.tableView.scrollEnabled = YES;
        [self enableButtons];
        self.notAuthenticatedMessageView.hidden = YES;
        [super loadInitialTweets];
    }
    else{
        self.tableView.scrollEnabled = NO;
        [self disableButtons];
        [self.tweets removeAllObjects];
        [self.tableView reloadData];
        self.notAuthenticatedMessageView = [[UIView alloc] initWithFrame:CGRectMake(25, 80, 270, 135)];
        self.notAuthenticatedMessageView.backgroundColor = [UIColor blackColor];
        self.notAuthenticatedMessageView.alpha = ALPHA_LEVEL;  
        self.notAuthenticatedMessageView.layer.cornerRadius = 10.0;
        UITextView *notAuthenticatedTextView = [[UITextView alloc] initWithFrame:CGRectMake(18, 20, 230, 135)];
        notAuthenticatedTextView.font = [UIFont systemFontOfSize:14];
        notAuthenticatedTextView.userInteractionEnabled = NO;
        notAuthenticatedTextView.text = @"You are currently not logged in. You can login to your twitter account via the twitter account screen in the settings tab.";
        notAuthenticatedTextView.backgroundColor = [UIColor clearColor];
        notAuthenticatedTextView.textColor = [UIColor whiteColor];
        [self.notAuthenticatedMessageView addSubview:notAuthenticatedTextView];
        [notAuthenticatedTextView release];
        [self.view addSubview:self.notAuthenticatedMessageView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    RefreshManager *refreshManager = [RefreshManager shared];
	if(refreshManager.myStreamScreenNeedsRefreshing){
        refreshManager.myStreamScreenNeedsRefreshing = NO;
        [self loadInitialTweets];
    }
}

- (void)dealloc{
    [notAuthenticatedMessageView release];
    [super dealloc];
}

@end
