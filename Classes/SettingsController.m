#import "SettingsController.h"
#import "SettingsTableViewCell.h"
#import "SettingsManager.h"
#import "FontSizeSelectionController.h"
#import "ResetDataManager.h"
#import "UpdateManager.h"
#import "RefreshManager.h"
#import "TwitterAccountController.h"
#import "ApplicationDataManager.h"

#define kSettingsOptionTwitterAccount 0
#define kSettingsOptionTweetListFontSize 10
#define kSettingsOptionTweetFontSize 11
#define kSettingsOptionShowRetweets 12
#define kSettingsOptionLastUpdated 20
#define kSettingsOptionCurrentVersion 21
#define kSettingsOptionAutoUpdate 22
#define kSettingsOptionLastUpdateCheck 23
#define kSettingsOptionCheckForUpdates 24
#define kSettingsOptionResetData 30
#define kSettingsTweetListFontSizePropertyName @"TweetListFontSize"
#define kSettingsTweetFontSizePropertyName @"TweetFontSize"

@implementation SettingsController

- (void)viewDidLoad{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor clearColor];
    messageView = [[MessageView alloc] init];
    [self.view addSubview:messageView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(section == 1){
        return 3;   
    }
    else if(section == 2){
        return 5;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	int row = (indexPath.section * 10) + indexPath.row;
    NSString* cellIdentifier = @"Cell";
	
	SettingsTableViewCell *cell = (SettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil){
		cell = [[SettingsTableViewCell alloc] initWithReuseIdentifier:cellIdentifier];
    }
	
    [cell setOnOffSegmentedControlIsVisible:NO];
    [cell setExtraDetailLabelIsVisible:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    SettingsManager *settingsManager = [SettingsManager shared];
    
    if(row == kSettingsOptionTwitterAccount){
        [cell setText:@"Twitter Account"];
        [cell accessoryViewIsVisible:YES];
    }
    else if(row == kSettingsOptionTweetListFontSize){
        [cell setText:@"List Font Size"];
        [cell setExtraDetailLabelIsVisible:YES];
        [cell setExtraDetailLabelText:[NSString stringWithFormat:@"%ipt", settingsManager.tweetListFontSize]];
        [cell accessoryViewIsVisible:YES];
    }
    else if(row == kSettingsOptionTweetFontSize){
        [cell setText:@"Tweet Font Size"];
        [cell setExtraDetailLabelIsVisible:YES];
        [cell setExtraDetailLabelText:[NSString stringWithFormat:@"%ipt", settingsManager.tweetFontSize]];
        [cell accessoryViewIsVisible:YES];
    }
    else if(row == kSettingsOptionShowRetweets){
        [cell setText:@"Show Retweets"];
        [cell setOnOffSegmentedControlIsVisible:YES];
        [cell setOnOffSegmentedControlIsOn:settingsManager.showRetweets];
        [cell setOnOffSegmentedControlTarget:self andSelector:@selector(showRetweetsControlClicked:)];
        [cell accessoryViewIsVisible:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(row == kSettingsOptionLastUpdated){
        [cell setText:@"Last Updated"];
        [cell setExtraDetailLabelIsVisible:YES];
        [cell setExtraDetailLabelText:[[UpdateManager shared] formattedLastUpdatedTime]];
        [cell accessoryViewIsVisible:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(row == kSettingsOptionLastUpdateCheck){
        [cell setText:@"Last Check"];
        [cell setExtraDetailLabelIsVisible:YES];
        [cell setExtraDetailLabelText:[[UpdateManager shared] formattedDateOfLastUpdateCheck]];
        [cell accessoryViewIsVisible:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(row == kSettingsOptionCurrentVersion){
        [cell setText:@"Current Version"];
        [cell setExtraDetailLabelIsVisible:YES];
        [cell setExtraDetailLabelText:[NSString stringWithFormat:@"%i", [[ApplicationDataManager shared] currentVersion]]];
        [cell accessoryViewIsVisible:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(row == kSettingsOptionAutoUpdate){
        [cell setText:@"Auto Update"];
        [cell setOnOffSegmentedControlIsVisible:YES];
        [cell setOnOffSegmentedControlIsOn:[[UpdateManager shared] autoUpdate]];
        [cell setOnOffSegmentedControlTarget:self andSelector:@selector(autoUpdateControlClicked:)];
        [cell accessoryViewIsVisible:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if(row == kSettingsOptionCheckForUpdates){
        [cell setText:@"Check For Updates"];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        [cell accessoryViewIsVisible:NO];
    }
    else if(row == kSettingsOptionResetData){
        [cell setText:@"Reset Data"];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        [cell accessoryViewIsVisible:NO];
    }
    else{
        [cell setText:@""];
        [cell accessoryViewIsVisible:NO];
    }

	return cell;
}

- (void)autoUpdateControlClicked:(UISegmentedControl *)sender{
    UpdateManager *updateManager = [UpdateManager shared];
    updateManager.autoUpdate = sender.selectedSegmentIndex == 0;
}

- (void)showRetweetsControlClicked:(UISegmentedControl *)sender{
    SettingsManager *settingsManager = [SettingsManager shared];
    settingsManager.showRetweets = sender.selectedSegmentIndex == 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row = (indexPath.section * 10) + indexPath.row;
    SettingsManager *settingsManager = [SettingsManager shared];
    if(row == kSettingsOptionTweetListFontSize){
        FontSizeSelectionController *fontSizeSelectionController = [[FontSizeSelectionController alloc] initWithPropertyName:kSettingsTweetListFontSizePropertyName andMinSize:10 andMaxSize:24 andCurrentValue:settingsManager.tweetListFontSize andDelegate:self];
        [self.navigationController pushViewController:fontSizeSelectionController animated:YES];
        [fontSizeSelectionController release];
    }
    else if(row == kSettingsOptionTweetFontSize){
        FontSizeSelectionController *fontSizeSelectionController = [[FontSizeSelectionController alloc] initWithPropertyName:kSettingsTweetFontSizePropertyName andMinSize:10 andMaxSize:24 andCurrentValue:settingsManager.tweetFontSize andDelegate:self];
        [self.navigationController pushViewController:fontSizeSelectionController animated:YES];
        [fontSizeSelectionController release];
    }
    else if(row == kSettingsOptionResetData){
        UIAlertView *confirmResetDataAlertView = [[UIAlertView alloc] initWithTitle:@"Reset Data" message:@"Are you sure you want to reset all data?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset", nil];
        confirmResetDataAlertView.tag = 0;
        [confirmResetDataAlertView show];
        [confirmResetDataAlertView release];
    }
    else if(row == kSettingsOptionCheckForUpdates){
        [messageView showLoadingMessage:@"Updating..." andCenterInTableView:self.tableView];
        UpdateManager *updateManager = [UpdateManager shared];
        updateManager.delegate = self;
        [updateManager checkForUpdates];
    }
    else if(row == kSettingsOptionTwitterAccount){
        TwitterAccountController *twitterAccountController = [[TwitterAccountController alloc] init];
        [self.navigationController pushViewController:twitterAccountController animated:YES];
        [twitterAccountController release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 0 && buttonIndex == 1){
        [[ResetDataManager shared] resetData];
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	NSString *sectionTitle;
    if(section == 0){
        sectionTitle = @"Accounts";
    }
    else if(section == 1){
        sectionTitle = @"Display";
    }
    else if (section == 2){
        sectionTitle = @"Data Updates";
    }
    else{
        sectionTitle = @"Advanced";
    }
    
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10,10,100,50)] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.text = [NSString stringWithFormat:@"   %@", sectionTitle];
	label.font = [UIFont boldSystemFontOfSize:16];
	label.textColor = [UIColor blackColor];
	return label;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 38;
}

- (void)didSelectFontSizeOf:(int)fontSize forPropertyName:(NSString *)propertyName{
    SettingsManager *settingsManager = [SettingsManager shared];
    RefreshManager *refreshManager = [RefreshManager shared];
    if([propertyName isEqualToString:kSettingsTweetListFontSizePropertyName]){
        settingsManager.tweetListFontSize = fontSize;
        refreshManager.tweetListScreenNeedsRefreshing = YES;
    }
    else if([propertyName isEqualToString:kSettingsTweetFontSizePropertyName]){
        settingsManager.tweetFontSize = fontSize;
        refreshManager.tweetScreenNeedsRefreshing = YES;
    }
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateManagerDidFinishUpdating{
    [messageView hide];
    [messageView showSuccessMessage:@"Successfully updated."];
    [self.tableView reloadData];
}

- (void)updateManagerDidFinishWithNoNewUpdates{
    [messageView hide];
    [messageView showSuccessMessage:@"No updates available."];
    [self.tableView reloadData];
}

- (void)updateManagerDidFailToUpdateWithError:(NSString *)errorMessage{
    [messageView hide];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
}

- (void)dealloc {
    [messageView release];
    [super dealloc];
}


@end;
