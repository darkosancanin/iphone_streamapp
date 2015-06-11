#import <QuartzCore/QuartzCore.h>
#import "SearchController.h"
#import "TweetTypeDetails.h"
#import "TweetsManager.h"
#import "Global.h"
#import "GANTracker.h"

@implementation SearchController

@synthesize searchBar;

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self == [super initWithCoder:aDecoder]){
        tweetsManager = [[TweetsManager alloc] initWithTweetsManagerDelegate:self];
        self.tweetTypeDetails = [[TweetTypeDetails alloc] initAsSearch];
        self.title = @"Search";
        shouldLoadTweets = NO;
    }
	return self;
}

- (id)initWithSearchTerm:(NSString *)theSearchTerm{
    if(self == [super init]){
        tweetsManager = [[TweetsManager alloc] initWithTweetsManagerDelegate:self];
        self.tweetTypeDetails = [[TweetTypeDetails alloc] initWithSearchTerm:theSearchTerm];
        self.title = @"Search";
        shouldLoadTweets = YES;
    }
	return self;
}

- (void)viewDidLoad {
    [self setUpSearchBox];
    [super viewDidLoad];
    shouldLoadTweets = YES;
}

- (void)setUpSearchBox{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.searchBar.tintColor = [UIColor clearColor];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.text = self.tweetTypeDetails.searchTerm;
    self.tableView.tableHeaderView = self.searchBar;
}

- (void)loadInitialTweets{
    if(shouldLoadTweets){
        [super loadInitialTweets];
    }
    else{
        [self.searchBar becomeFirstResponder];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.tweetTypeDetails.searchTerm = self.searchBar.text;
    [self.searchBar resignFirstResponder];
    [self loadInitialTweets];
    
    NSError *error;
	if (![[GANTracker sharedTracker] trackEvent:@"Search" action:@"Search" label:self.searchBar.text value:-1 withError:&error]) {
		NSLog(@"Error tracking page using google analytics: %@", error);
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	[self.searchBar resignFirstResponder];
}

- (void)dealloc{
    [searchBar release];
    [super dealloc];
}

@end
