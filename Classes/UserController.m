#import "UserController.h"
#import "WebViewController.h"
#import "TweetsController.h"
#import "Button.h"
#import "FavouritesManager.h"
#import "Global.h"
#import "GANTracker.h"
#import "SearchController.h"

static NSString *USER_INFO_SECTION_LOCATION = @"Location";
static NSString *USER_INFO_SECTION_BIO = @"Bio";
static NSString *USER_INFO_SECTION_URL = @"Web";
static NSString *USER_INFO_SECTION_FOLLOWERS = @"Followers";
static NSString *USER_INFO_SECTION_TWEETS = @"Tweets";
static NSString *USER_INFO_SECTION_VERIFIED = @"Verified";

@implementation UserController

@synthesize user, userInfoToDisplay, tweetsManager, messageView, userInfoHeaderView, favouritesButton;

- (id)initWithAUser:(User *)theUser{
	if((self = [super initWithStyle:UITableViewStyleGrouped])){
		self.user = theUser;
        self.userInfoToDisplay = [[NSMutableArray alloc] init];
        tweetsManager = [[TweetsManager alloc] initWithTweetsManagerDelegate:self];
        messageView = [[MessageView alloc] init];
        [self.view addSubview:messageView];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self setUpRefreshButton];
	[self setUpUserInfoHeaderView];
    [self startLoadingUserInfo];
    
    NSError *error;
	NSString *url = [NSString stringWithFormat:@"/user/%@", self.user.userName];
	if (![[GANTracker sharedTracker] trackPageview:url withError:&error]) {
		NSLog(@"Error tracking page using google analytics: %@", error);
	}
}

- (void)setUpRefreshButton{
	refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonClicked)];
}

- (void)setUpUserInfoHeaderView{
	self.userInfoHeaderView = [[UserInfoHeaderView alloc] initWithFullName:self.user.fullName andUserName:self.user.userName andProfileImageUrl:self.user.profileImageUrl andDisplayAccessoryArrow:NO];
    [self.userInfoHeaderView addProfileImageTouchEventTarget:self action:@selector(profileImageViewClicked)];
	self.tableView.tableHeaderView = userInfoHeaderView;
}

- (void)profileImageViewClicked{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""]]];
    WebViewController *webViewController = [[WebViewController alloc] initWithUrlRequest:urlRequest];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
}

- (void)setButtonsInFooterView{
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
    
    self.favouritesButton = [[Button alloc] initWithFrame:CGRectMake(10, 5, 300, 45) andTitle:@""];
    [self.favouritesButton addTarget:self action:@selector(favouritesButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.favouritesButton];
    [self setTitleOnFavouritesButton];
    
    Button *viewTweetsButton = [[Button alloc] initWithFrame:CGRectMake(10, 60, 300, 45) andTitle:@"View Tweets"];
    [viewTweetsButton addTarget:self action:@selector(viewTweetsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:viewTweetsButton];
    [viewTweetsButton release];

    NSString *searchUserNameButtonTitle = [NSString stringWithFormat:@"Search @%@", self.user.userName];
    Button *searchUsernameButton = [[Button alloc] initWithFrame:CGRectMake(10, 115, 300, 45) andTitle:searchUserNameButtonTitle];
    [searchUsernameButton addTarget:self action:@selector(searchUsernameButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:searchUsernameButton];
    [searchUsernameButton release];
    
    Button *viewTwitterPageButton = [[Button alloc] initWithFrame:CGRectMake(10, 170, 300, 45) andTitle:@"View Twitter Page"];
    [viewTwitterPageButton addTarget:self action:@selector(viewTwitterPageButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:viewTwitterPageButton];
    [viewTwitterPageButton release];
    
    
	self.tableView.tableFooterView = footerView;
    [footerView release];
}

- (void)setTitleOnFavouritesButton{
    if([[FavouritesManager shared] isUserAFavourite:self.user.userName]){
        [self.favouritesButton setTitle:@"Remove from Favourites" forState:UIControlStateNormal];
        [self.favouritesButton showFavouritesStar];
    }
    else {
        [self.favouritesButton setTitle:@"Add to Favourites" forState:UIControlStateNormal];
        [self.favouritesButton showBlankFavouritesStar];
    }
}

- (void)searchUsernameButtonClicked{
    SearchController *searchController = [[SearchController alloc] initWithSearchTerm:[NSString stringWithFormat:@"@%@", self.user.userName]];
    [self.navigationController pushViewController:searchController animated:YES];
    [searchController release];
}

- (void)viewTwitterPageButtonClicked{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.twitter.com/%@", self.user.userName]]];
    WebViewController *webViewController = [[WebViewController alloc] initWithUrlRequest:urlRequest];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
}

- (void)favouritesButtonClicked{
    FavouritesManager *favouritesManager = [FavouritesManager shared];
    if([favouritesManager isUserAFavourite:self.user.userName]){
        [favouritesManager removeUserFromFavourites:self.user.userName];
    }
    else{
        [favouritesManager addUserToFavourites:self.user.userName];
    }
    [self setTitleOnFavouritesButton];
}

- (void)viewTweetsButtonClicked{
    TweetTypeDetails *tweetTypeDetails = [[TweetTypeDetails alloc] initWithAUser:self.user];
    TweetsController *tweetsController = [[TweetsController alloc] initWithTweetTypeDetails:tweetTypeDetails];
    [self.navigationController pushViewController:tweetsController animated:YES];
    [tweetsController release];
    [tweetTypeDetails release];
}

- (void)startLoadingUserInfo{
    [self.messageView showLoadingMessage];
    self.tableView.tableFooterView = nil;
    [self.tweetsManager getUserForUserName:self.user.userName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userInfoToDisplay.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *userInfoSection = [self.userInfoToDisplay objectAtIndex:indexPath.row];
    if(userInfoSection == USER_INFO_SECTION_BIO){
        CGSize bioTextSize = [self.user.bio sizeWithFont:[UIFont systemFontOfSize:14.0]
                                        constrainedToSize:CGSizeMake(210, 9999)
                                            lineBreakMode:UILineBreakModeWordWrap];
        return bioTextSize.height + 19;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *userInfoSection = [self.userInfoToDisplay objectAtIndex:indexPath.row];
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:userInfoSection];
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:userInfoSection] autorelease];
        cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_LEVEL];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        if(userInfoSection == USER_INFO_SECTION_URL){
            UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_arrow.png"]];
            cell.accessoryView = accessoryView;
            [accessoryView release];
        }
        else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
	}
    
    if(userInfoSection == USER_INFO_SECTION_LOCATION){
        cell.textLabel.text = USER_INFO_SECTION_LOCATION;
        cell.detailTextLabel.text = self.user.location;
    }
    else if(userInfoSection == USER_INFO_SECTION_BIO){
        cell.textLabel.text = USER_INFO_SECTION_BIO;
        cell.detailTextLabel.text = self.user.bio;
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.detailTextLabel.numberOfLines = 0;
    }
    else if(userInfoSection == USER_INFO_SECTION_URL){
        cell.textLabel.text = USER_INFO_SECTION_URL;
        cell.detailTextLabel.text = self.user.url;
    }
    else if(userInfoSection == USER_INFO_SECTION_FOLLOWERS){
        cell.textLabel.text = USER_INFO_SECTION_FOLLOWERS;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%li", self.user.numberOfFollowers];
    }
    else if(userInfoSection == USER_INFO_SECTION_TWEETS){
        cell.textLabel.text = USER_INFO_SECTION_TWEETS;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%li", self.user.numberOfTweets];
    }
    else if(userInfoSection == USER_INFO_SECTION_VERIFIED){
        cell.textLabel.text = USER_INFO_SECTION_VERIFIED;
        cell.detailTextLabel.text = self.user.verified ? @"Yes" : @"No";
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *userInfoSection = [self.userInfoToDisplay objectAtIndex:indexPath.row];
    if(userInfoSection == USER_INFO_SECTION_URL){
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.user.url]];
        WebViewController *webViewController = [[WebViewController alloc] initWithUrlRequest:urlRequest];
        [self.navigationController pushViewController:webViewController animated:YES];
        [webViewController release];
    }
}

- (void)enableRefreshButton{
	self.navigationItem.rightBarButtonItem = refreshButton;
}

- (void)disableRefreshButton{
	self.navigationItem.rightBarButtonItem = nil;
}

- (void) refreshButtonClicked{
	[self startLoadingUserInfo];
}

- (void)tweetManagerRequestFailedWithError:(NSString *)error{
    [self.messageView hide];
    [self enableRefreshButton];
    [self setButtonsInFooterView];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
}

- (void)tweetManagerDidReceiveUser:(User *)theUser{
    [self.messageView hide];
    [self disableRefreshButton];
    [self setButtonsInFooterView];
    self.user = theUser;
    [self.userInfoHeaderView updateFullName:theUser.fullName andUserName:theUser.userName andProfileImageUrl:theUser.profileImageUrl];
    [self refreshTable];
}

- (void)refreshTable{
    [self.userInfoToDisplay removeAllObjects];
    if(self.user.location && self.user.location.length > 2) [self.userInfoToDisplay addObject:USER_INFO_SECTION_LOCATION];
    if(self.user.bio && self.user.bio.length > 2) [self.userInfoToDisplay addObject:USER_INFO_SECTION_BIO];
    if(self.user.url && self.user.url.length > 2) [self.userInfoToDisplay addObject:USER_INFO_SECTION_URL];
    [self.userInfoToDisplay addObject:USER_INFO_SECTION_FOLLOWERS];
    [self.userInfoToDisplay addObject:USER_INFO_SECTION_TWEETS];
    if(self.user.numberOfTweets > 0) [self.userInfoToDisplay addObject:USER_INFO_SECTION_VERIFIED];
    [self.tableView reloadData];
}

- (void)dealloc {
    [refreshButton release];
    [favouritesButton release];
    [userInfoHeaderView release];
    [messageView release];
    [tweetsManager release];
    [userInfoToDisplay release];
	[user release];
    [super dealloc];
}

@end
