#import <Foundation/Foundation.h>
#import "User.h"
#import "TweetsManager.h"
#import "MessageView.h"
#import "UserInfoHeaderView.h"
#import "Button.h"

@interface UserController : UITableViewController<TweetsManagerDelegate> {
	User *user;
    NSMutableArray *userInfoToDisplay;
    TweetsManager *tweetsManager;
    MessageView *messageView;
    UserInfoHeaderView *userInfoHeaderView;
    Button *favouritesButton;
    UIBarButtonItem *refreshButton;
}

@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSMutableArray *userInfoToDisplay;
@property (nonatomic, retain) TweetsManager *tweetsManager;
@property (nonatomic, retain) MessageView *messageView;
@property (nonatomic, retain) UserInfoHeaderView *userInfoHeaderView;
@property (nonatomic, retain) Button *favouritesButton;

- (id)initWithAUser:(User *)theUser;
- (void)setUpUserInfoHeaderView;
- (void)setButtonsInFooterView;
- (void)refreshTable;
- (void)startLoadingUserInfo;
- (void)setTitleOnFavouritesButton;
- (void)setUpRefreshButton;
- (void)enableRefreshButton;
- (void)disableRefreshButton;

@end
