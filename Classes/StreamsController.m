#import "StreamsController.h"
#import "StreamsManager.h"
#import "StreamSection.h"
#import "Stream.h"
#import "TweetsController.h"
#import "TweetTypeDetails.h"
#import "Global.h"
#import "StreamUsersController.h"
#import "RefreshManager.h"

@implementation StreamsController

@synthesize streamCategories, streamIndexPathToShowUsersFor, streamsTableView, categoriesSegmentedControl, sectionHeaderViews, indexBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionHeaderViews = [[[NSMutableDictionary alloc] init] autorelease];
    self.streamCategories = [[StreamsManager shared] getStreamCategories];
    [self setUpTableView];
}

- (void)setUpTableView{
    if(self.streamsTableView){
        [self.streamsTableView removeFromSuperview];
    }
    self.streamsTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped] autorelease];
    self.streamsTableView.backgroundColor = [UIColor clearColor];
    self.streamsTableView.delegate = self;
    self.streamsTableView.dataSource = self;
    [self.view addSubview:self.streamsTableView];
    
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    for (StreamCategory *streamCategory in self.streamCategories){
        [categories addObject:streamCategory.name];
    }
    self.categoriesSegmentedControl = [[[UISegmentedControl alloc] initWithItems:categories] autorelease];
    [categories release];
    self.categoriesSegmentedControl.frame = CGRectMake(10, 10, 300, 30);
    self.categoriesSegmentedControl.selectedSegmentIndex = 0;
    self.categoriesSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.categoriesSegmentedControl.tintColor = [UIColor darkGrayColor];
    [self.categoriesSegmentedControl addTarget:self action:@selector(categoriesControlClicked) forControlEvents:UIControlEventValueChanged];
    
    if(self.streamCategories.count > 1){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [headerView addSubview:self.categoriesSegmentedControl];
        self.streamsTableView.tableHeaderView = headerView;
        [headerView release];
    }
    
    [self setUpIndexBar];
    [self setUpLongPressGestureRecognition];
}

- (void)setUpIndexBar{
    if(self.indexBar){
        [self.indexBar removeFromSuperview];
    }
    StreamCategory *streamCategory = [self getSelectedStreamCategory];
    if(streamCategory.isSectionsSortedAlphabetically){
        self.streamsTableView.frame = CGRectMake(self.streamsTableView.frame.origin.x, self.streamsTableView.frame.origin.y, 300, self.streamsTableView.frame.size.height);
        self.streamsTableView.showsVerticalScrollIndicator = NO;
        self.categoriesSegmentedControl.frame = CGRectMake(self.categoriesSegmentedControl.frame.origin.x, self.categoriesSegmentedControl.frame.origin.y, 280, self.categoriesSegmentedControl.frame.size.height);
        self.indexBar = [[[CMIndexBar alloc] initWithFrame:CGRectMake(self.view.frame.size.width-28, 5.0, 25.0, 357)] autorelease];
        self.indexBar.delegate = self;
        self.indexBar.highlightedBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_LEVEL];
        [self.view addSubview:self.indexBar];
        [self setIndexBarIndexValues];
    }
    else{
        self.streamsTableView.showsVerticalScrollIndicator = YES;
        self.streamsTableView.frame = CGRectMake(0, 0, 320, 367);
        self.categoriesSegmentedControl.frame = CGRectMake(10, 10, 300, 30);
    }
}

- (void)setIndexBarIndexValues{
    StreamCategory *streamCategory = [self getSelectedStreamCategory];
    NSMutableArray *indexValues = [[NSMutableArray alloc] initWithCapacity:streamCategory.streamSections.count];
    for(StreamSection *streamSection in streamCategory.streamSections){
        [indexValues addObject:[NSString stringWithFormat:@"%@",[streamSection.name substringWithRange:NSMakeRange(0, 1)]]];
    }
    [self.indexBar setIndexes:indexValues withCategoriesIndex:self.streamCategories.count > 1];
    [indexValues release];
}

- (void)indexSelectionDidChange:(CMIndexBar *)IndexBar:(int)index{
    [self.streamsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)didSelectCategoriesIndex{
    [self.streamsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)categoriesControlClicked{
	[self setUpIndexBar];
    [self.streamsTableView reloadData];
}

- (void)setUpLongPressGestureRecognition{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = LONG_PRESS_GESTURE_RECOGNITION_PRESS_DURATION;
    [self.streamsTableView addGestureRecognizer:longPressGestureRecognizer];
    [longPressGestureRecognizer release];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(self.streamIndexPathToShowUsersFor != nil) return;
    CGPoint p = [gestureRecognizer locationInView:self.streamsTableView];
    NSIndexPath *indexPath = [self.streamsTableView indexPathForRowAtPoint:p];
    if (indexPath != nil){
        self.streamIndexPathToShowUsersFor = indexPath;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Show Users", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        [actionSheet release];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        StreamCategory *streamCategory = [self getSelectedStreamCategory];
        StreamSection *streamSection = [streamCategory.streamSections objectAtIndex:self.streamIndexPathToShowUsersFor.section];
        Stream *stream = [streamSection.streams objectAtIndex:self.streamIndexPathToShowUsersFor.row];
		StreamUsersController *streamUsersController = [[StreamUsersController alloc] initWithStream:stream];
        [self.navigationController pushViewController:streamUsersController animated:YES];
        [streamUsersController release];
	}
    
    self.streamIndexPathToShowUsersFor = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    StreamCategory *streamCategory = [self getSelectedStreamCategory];
	StreamSection *streamSection = [streamCategory.streamSections objectAtIndex:section];
	return streamSection.streams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString* cellIdentifier = @"StreamCell";
	
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
	
    StreamCategory *streamCategory = [self getSelectedStreamCategory];
	StreamSection *streamSection = [streamCategory.streamSections objectAtIndex:indexPath.section];
	Stream *stream = [streamSection.streams objectAtIndex:indexPath.row];
	cell.textLabel.text = stream.name;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    StreamCategory *streamCategory = [self getSelectedStreamCategory];
	StreamSection *streamSection = [streamCategory.streamSections objectAtIndex:indexPath.section];
	Stream *stream = [streamSection.streams objectAtIndex:indexPath.row];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Streams" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
	TweetTypeDetails *tweetTypeDetails = [[TweetTypeDetails alloc] initWithStream:stream];
	TweetsController *tweetsController = [[TweetsController alloc] initWithTweetTypeDetails:tweetTypeDetails];
	[tweetTypeDetails release];
	[self.navigationController pushViewController:tweetsController animated:YES];
	[tweetsController release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    StreamCategory *streamCategory = [self getSelectedStreamCategory];
	return streamCategory.streamSections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    StreamCategory *streamCategory = [self getSelectedStreamCategory];
	StreamSection *streamSection = [streamCategory.streamSections objectAtIndex:section];
	return streamSection.name;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	StreamCategory *streamCategory = [self getSelectedStreamCategory];
	StreamSection *streamSection = [streamCategory.streamSections objectAtIndex:section];
	if(![streamSection hasVisibleName]) return nil;
    
    UILabel *headerView = [self.sectionHeaderViews objectForKey:streamSection.name];
    if(!headerView) {
        headerView = [[[UILabel alloc] initWithFrame:CGRectMake(10,10,100,50)] autorelease];
        headerView.backgroundColor = [UIColor clearColor];
        headerView.text = [NSString stringWithFormat:@"   %@", streamSection.name];
        headerView.font = [UIFont boldSystemFontOfSize:16];
        headerView.textColor = [UIColor blackColor];
        [self.sectionHeaderViews setObject:headerView forKey:streamSection.name];
    }

	return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	StreamCategory *streamCategory = [self getSelectedStreamCategory];
	StreamSection *streamSection = [streamCategory.streamSections objectAtIndex:section];
	if([streamSection hasVisibleName]) {
		return 38;
	}else {
		return 0;
	}
}

- (StreamCategory *)getSelectedStreamCategory{
    return [self.streamCategories objectAtIndex:self.categoriesSegmentedControl.selectedSegmentIndex];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if([[RefreshManager shared] streamsScreenNeedsRefreshing]){
        [[RefreshManager shared] setStreamsScreenNeedsRefreshing:NO];
        self.streamCategories = [[StreamsManager shared] getStreamCategories];
        [self setUpTableView];
		[self.streamsTableView reloadData];
    }
}

- (void)dealloc {
    [indexBar release];
    [sectionHeaderViews release];
    [categoriesSegmentedControl release];
    [streamsTableView release];
    [streamIndexPathToShowUsersFor release];
	[streamCategories release];
    [super dealloc];
}

@end
