#import <QuartzCore/QuartzCore.h>
#import "FavouritesController.h"
#import "TweetTypeDetails.h"
#import "TweetsManager.h"
#import "FavouritesManager.h"
#import "Global.h"
#import "RefreshManager.h"
#import "GANTracker.h"

@implementation FavouritesController

@synthesize noFavouritesSelectedMessageView;

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self == [super initWithCoder:aDecoder]){
        tweetsManager = [[TweetsManager alloc] initWithTweetsManagerDelegate:self];
        self.tweetTypeDetails = [[TweetTypeDetails alloc] initAsFavourites];
    }
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Favourites";
}

- (void)loadInitialTweets{
    FavouritesManager *favouritesManager = [FavouritesManager shared];
    if([favouritesManager favouritesHaveBeenSelected]){
        self.tableView.scrollEnabled = YES;
        [self enableButtons];
        self.noFavouritesSelectedMessageView.hidden = YES;
        [super loadInitialTweets];
    }
    else{
        self.tableView.scrollEnabled = NO;
        [self disableButtons];
        [self.tweets removeAllObjects];
        [self.tableView reloadData];
        self.noFavouritesSelectedMessageView = [[UIView alloc] initWithFrame:CGRectMake(25, 80, 270, 220)];
        self.noFavouritesSelectedMessageView.backgroundColor = [UIColor blackColor];
        self.noFavouritesSelectedMessageView.alpha = ALPHA_LEVEL;  
        self.noFavouritesSelectedMessageView.layer.cornerRadius = 10.0;
        UITextView *noFavouritesTextView = [[UITextView alloc] initWithFrame:CGRectMake(18, 20, 230, 185)];
        noFavouritesTextView.font = [UIFont systemFontOfSize:14];
        noFavouritesTextView.userInteractionEnabled = NO;
        noFavouritesTextView.text = @"You currently have no favourites selected. To add users to favourites, press the 'Add To Favourites' button on the user details screen. You can access this screen by pressing on a tweet and then pressing the user details button at the top of the screen.";
        noFavouritesTextView.backgroundColor = [UIColor clearColor];
        noFavouritesTextView.textColor = [UIColor whiteColor];
        [self.noFavouritesSelectedMessageView addSubview:noFavouritesTextView];
        [noFavouritesTextView release];
        [self.view addSubview:self.noFavouritesSelectedMessageView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if([[RefreshManager shared] favouritesScreenNeedsRefreshing]){
        [self loadInitialTweets];
        [[RefreshManager shared] setFavouritesScreenNeedsRefreshing:NO];
    }
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/favourites" withError:&error]) {
        NSLog(@"Error tracking page using google analytics: %@", error);
    }
}

- (void)dealloc{
    [noFavouritesSelectedMessageView release];
    [super dealloc];
}

@end
