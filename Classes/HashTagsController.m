#import "HashTagsController.h"
#import "HashTagsManager.h"
#import "HashTagsSection.h"
#import "HashTagCollection.h"
#import "TweetsController.h"
#import "TweetTypeDetails.h"
#import "Global.h"
#import "HashTagCollectionHashTagsController.h"
#import "RefreshManager.h"

@implementation HashTagsController

@synthesize hashTagsCategories, hashTagCollectionIndexPathToShowUsersFor, hashTagsTableView, categoriesSegmentedControl, sectionHeaderViews, indexBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionHeaderViews = [[[NSMutableDictionary alloc] init] autorelease];
	self.hashTagsCategories = [[HashTagsManager shared] getHashTagsCategories];
    [self setUpTableView];
}

- (void)setUpTableView{
    if(self.hashTagsTableView){
        [self.hashTagsTableView removeFromSuperview];
    }
    self.hashTagsTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped] autorelease];
    self.hashTagsTableView.backgroundColor = [UIColor clearColor];
    self.hashTagsTableView.delegate = self;
    self.hashTagsTableView.dataSource = self;
    [self.view addSubview:self.hashTagsTableView];
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for (HashTagsCategory *hashTagsCategory in self.hashTagsCategories){
        [categories addObject:hashTagsCategory.name];
    }
    self.categoriesSegmentedControl = [[[UISegmentedControl alloc] initWithItems:categories] autorelease];
    [categories release];
    self.categoriesSegmentedControl.frame = CGRectMake(10, 10, 300, 30);
    self.categoriesSegmentedControl.selectedSegmentIndex = 0;
    self.categoriesSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.categoriesSegmentedControl.tintColor = [UIColor darkGrayColor];
    [self.categoriesSegmentedControl addTarget:self action:@selector(categoriesControlClicked) forControlEvents:UIControlEventValueChanged];
    
    if(self.hashTagsCategories.count > 1){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [headerView addSubview:self.categoriesSegmentedControl];
        self.hashTagsTableView.tableHeaderView = headerView;
        [headerView release];
    }
    
    [self setUpIndexBar];
    [self setUpLongPressGestureRecognition];
}

- (void)setUpIndexBar{
    if(self.indexBar){
        [self.indexBar removeFromSuperview];
    }
    HashTagsCategory *hashTagsCategory = [self getSelectedHashTagsCategory];
    if(hashTagsCategory.isSectionsSortedAlphabetically){
        self.hashTagsTableView.frame = CGRectMake(self.hashTagsTableView.frame.origin.x, self.hashTagsTableView.frame.origin.y, 300, self.hashTagsTableView.frame.size.height);
        self.hashTagsTableView.showsVerticalScrollIndicator = NO;
        self.categoriesSegmentedControl.frame = CGRectMake(self.categoriesSegmentedControl.frame.origin.x, self.categoriesSegmentedControl.frame.origin.y, 280, self.categoriesSegmentedControl.frame.size.height);
        self.indexBar = [[[CMIndexBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width-28, 5.0, 25.0, 357)] autorelease];
        self.indexBar.delegate = self;
        self.indexBar.highlightedBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_LEVEL];
        [self.view addSubview:self.indexBar];
        [self setIndexBarIndexValues];
    }
    else{
        self.hashTagsTableView.showsVerticalScrollIndicator = YES;
        self.hashTagsTableView.frame = CGRectMake(0, 0, 320, 367);
        self.categoriesSegmentedControl.frame = CGRectMake(10, 10, 300, 30);
    }
}

- (void)setIndexBarIndexValues{
    HashTagsCategory *hashTagsCategory = [self getSelectedHashTagsCategory];
    NSMutableArray *indexValues = [[NSMutableArray alloc] initWithCapacity:hashTagsCategory.hashTagSections.count];
    for(HashTagsSection *hashTagsSection in hashTagsCategory.hashTagSections){
        [indexValues addObject:[NSString stringWithFormat:@"%@",[hashTagsSection.name substringWithRange:NSMakeRange(0, 1)]]];
    }
    [self.indexBar  setIndexes:indexValues withCategoriesIndex:self.hashTagsCategories.count > 1];
    [indexValues release];
}

- (void)indexSelectionDidChange:(CMIndexBar *)IndexBar:(int)index{
    [self.hashTagsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)didSelectCategoriesIndex{
    [self.hashTagsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)categoriesControlClicked{
	[self setUpIndexBar];
    [self.hashTagsTableView reloadData];
}

- (void)setUpLongPressGestureRecognition{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = LONG_PRESS_GESTURE_RECOGNITION_PRESS_DURATION;
    [self.hashTagsTableView addGestureRecognizer:longPressGestureRecognizer];
    [longPressGestureRecognizer release];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(self.hashTagCollectionIndexPathToShowUsersFor != nil) return;
    CGPoint p = [gestureRecognizer locationInView:self.hashTagsTableView];
    NSIndexPath *indexPath = [self.hashTagsTableView indexPathForRowAtPoint:p];
    if (indexPath != nil){
        self.hashTagCollectionIndexPathToShowUsersFor = indexPath;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Show Hash Tags", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet release];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        HashTagsCategory *hashTagsCategory = [self getSelectedHashTagsCategory];
        HashTagsSection *hashTagsSection = [hashTagsCategory.hashTagSections objectAtIndex:self.hashTagCollectionIndexPathToShowUsersFor.section];
        HashTagCollection *hashTagCollection = [hashTagsSection.hashTagCollections objectAtIndex:self.hashTagCollectionIndexPathToShowUsersFor.row];
		HashTagCollectionHashTagsController *hashTagCollectionHashTagsController = [[HashTagCollectionHashTagsController alloc] initWithHashTagCollection:hashTagCollection];
        [self.navigationController pushViewController:hashTagCollectionHashTagsController animated:YES];
        [hashTagCollectionHashTagsController release];
	}
    
    self.hashTagCollectionIndexPathToShowUsersFor = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HashTagsCategory *hashTagsCategory = [self getSelectedHashTagsCategory];
	HashTagsSection *hashTagsSection = [hashTagsCategory.hashTagSections objectAtIndex:section];
	return hashTagsSection.hashTagCollections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString* cellIdentifier = @"HashTagCollectionCell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_arrow.png"]];
		cell.accessoryView = accessoryView;
		[accessoryView release];
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.textColor = [UIColor whiteColor];
		cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_LEVEL];
	}
	
    HashTagsCategory *hashTagsCategory = [self getSelectedHashTagsCategory];
	HashTagsSection *hashTagsSection = [hashTagsCategory.hashTagSections objectAtIndex:indexPath.section];
	HashTagCollection *hashTagCollection = [hashTagsSection.hashTagCollections objectAtIndex:indexPath.row];
	cell.textLabel.text = hashTagCollection.name;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    HashTagsCategory *hashTagsCategory = [self getSelectedHashTagsCategory];
	HashTagsSection *hashTagsSection = [hashTagsCategory.hashTagSections objectAtIndex:indexPath.section];
	HashTagCollection *hashTagCollection = [hashTagsSection.hashTagCollections objectAtIndex:indexPath.row];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Hash Tags" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
	TweetTypeDetails *tweetTypeDetails = [[TweetTypeDetails alloc] initWithHashTagCollection:hashTagCollection];
	TweetsController *tweetsController = [[TweetsController alloc] initWithTweetTypeDetails:tweetTypeDetails];
	[tweetTypeDetails release];
	[self.navigationController pushViewController:tweetsController animated:YES];
	[tweetsController release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    HashTagsCategory *hashTagsCategory = [self getSelectedHashTagsCategory];
	return hashTagsCategory.hashTagSections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	HashTagsCategory *hashTagsCategory = [self getSelectedHashTagsCategory];
	HashTagsSection *hashTagsSection = [hashTagsCategory.hashTagSections objectAtIndex:section];
	return hashTagsSection.name;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	HashTagsCategory *hashTagsCategory = [self getSelectedHashTagsCategory];
	HashTagsSection *hashTagsSection = [hashTagsCategory.hashTagSections objectAtIndex:section];
	if(![hashTagsSection hasVisibleName]) return nil;
	
    UILabel *headerView = [self.sectionHeaderViews objectForKey:hashTagsSection.name];
    if(!headerView) {
        headerView = [[[UILabel alloc] initWithFrame:CGRectMake(10,10,100,50)] autorelease];
        headerView.backgroundColor = [UIColor clearColor];
        headerView.text = [NSString stringWithFormat:@"   %@", hashTagsSection.name];
        headerView.font = [UIFont boldSystemFontOfSize:16];
        headerView.textColor = [UIColor blackColor];
        [self.sectionHeaderViews setObject:headerView forKey:hashTagsSection.name];
    }
    
	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	HashTagsCategory *hashTagsCategory = [self getSelectedHashTagsCategory];
	HashTagsSection *hashTagsSection = [hashTagsCategory.hashTagSections objectAtIndex:section];
	if([hashTagsSection hasVisibleName]) {
		return 38;
	}else {
		return 0;
	}
}

- (HashTagsCategory *)getSelectedHashTagsCategory{
    return [self.hashTagsCategories objectAtIndex:self.categoriesSegmentedControl.selectedSegmentIndex];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if([[RefreshManager shared] hashTagsScreenNeedsRefreshing]){
        [[RefreshManager shared] setHashTagsScreenNeedsRefreshing:NO];
        self.hashTagsCategories = [[HashTagsManager shared] getHashTagsCategories];
        [self setUpTableView];
		[self.hashTagsTableView reloadData];
    }
}

- (void)dealloc {
    [indexBar release];
    [sectionHeaderViews release];
    [categoriesSegmentedControl release];
    [hashTagCollectionIndexPathToShowUsersFor release];
	[hashTagsCategories release];
    [hashTagsTableView release];
    [super dealloc];
}

@end
