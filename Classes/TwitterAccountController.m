#import "TwitterAccountController.h"
#import "Global.h"
#import "Button.h"
#import "TwitterAccountManager.h"

#define USERNAME_TEXTFIELD_TAG 0
#define PASSWORD_TEXTFIELD_TAG 1

@implementation TwitterAccountController

- (id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.title = @"Twitter Account";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavigationButtons];
    [self setUpCreateAccountText];
    [self setUpMessageView];
}

- (void)viewDidAppear:(BOOL)animated{
    if([[TwitterAccountManager shared] isAuthenticated]){
        [userNameTextField resignFirstResponder];
    }
    else{
        [userNameTextField becomeFirstResponder];
    }
}

- (void)setUpCreateAccountText{
    UIView *footerView = [[UIView alloc] init];
    UILabel *createAccountText = [[UILabel alloc] init];
    createAccountText.frame = CGRectMake(10, 5, 300, 25);
    createAccountText.text = @"Note: If you do not have a twitter account, you can sign up for free at twitter.com";
    createAccountText.numberOfLines = 0;
    createAccountText.font = [UIFont systemFontOfSize:11];
    createAccountText.backgroundColor = [UIColor clearColor];
    createAccountText.textColor = [UIColor blackColor];
    createAccountText.shadowColor = [UIColor lightGrayColor];
    createAccountText.shadowOffset = CGSizeMake(0.3,0.3);
    createAccountText.textAlignment = UITextAlignmentCenter;
    [footerView addSubview:createAccountText];
    [createAccountText release];
    self.tableView.tableFooterView = footerView;
    [footerView release];
    [self setCreateTextAccountFooterVisiblity];
}

- (void)setUpMessageView{
	messageView = [[MessageView alloc] init];
    [self.view addSubview:messageView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[TwitterAccountManager shared] isAuthenticated])
    {
        return 1;
    }
    else{
        return 2;   
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterAccountManager *twitterAccountManger = [TwitterAccountManager shared];
    BOOL isAuthenticated = [twitterAccountManger isAuthenticated];
    
    if(indexPath.row == 0){
        static NSString *CellIdentifier = @"UserNameCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_LEVEL];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = @"Username";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
            userNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 10, 200, 24)];
            [userNameTextField addTarget:self action:@selector(updateNavigationButton) forControlEvents:UIControlEventEditingChanged];
            userNameTextField.delegate = self;
            userNameTextField.tag = USERNAME_TEXTFIELD_TAG;
            userNameTextField.textColor = [UIColor whiteColor];
            userNameTextField.backgroundColor = [UIColor clearColor];
            userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            [cell.contentView addSubview:userNameTextField];
        }
        
        if(isAuthenticated){
            userNameTextField.text = twitterAccountManger.twitterToken.userName;
        }
        userNameTextField.enabled = !isAuthenticated;
        
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"PasswordCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_LEVEL];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.text = @"Password";
            cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
            passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 10, 200, 24)];
            [passwordTextField addTarget:self action:@selector(updateNavigationButton) forControlEvents:UIControlEventEditingChanged];
            passwordTextField.delegate = self;
            passwordTextField.tag = PASSWORD_TEXTFIELD_TAG;
            passwordTextField.textColor = [UIColor whiteColor];
            passwordTextField.backgroundColor = [UIColor clearColor];
            passwordTextField.secureTextEntry = YES;
            [cell.contentView addSubview:passwordTextField];
        }
        passwordTextField.enabled = !isAuthenticated;
        return cell;
    }
}

- (void)updateNavigationButton{
    self.navigationItem.rightBarButtonItem.enabled = userNameTextField.text.length > 0 && passwordTextField.text.length > 0;
}

- (void)setUpNavigationButtons{
    if(![[TwitterAccountManager shared] isAuthenticated]) {
        UIBarButtonItem *signInButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStyleBordered target:self action:@selector(signInButtonClicked)];
        self.navigationItem.rightBarButtonItem = signInButton;
        [signInButton release];
    }
    else{
        UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStyleBordered target:self action:@selector(signOutButtonClicked)];
        self.navigationItem.rightBarButtonItem = signOutButton;
        [signOutButton release];
    }
    
    self.navigationItem.rightBarButtonItem.enabled = (userNameTextField.text.length > 0 && passwordTextField.text.length > 0) || [[TwitterAccountManager shared] isAuthenticated];
}

- (void)setCreateTextAccountFooterVisiblity{
    if([[TwitterAccountManager shared] isAuthenticated])
    {
        self.tableView.tableFooterView.hidden = YES;
    }
    else{
        self.tableView.tableFooterView.hidden = NO;   
    }
}

- (void)signInButtonClicked{
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [messageView showLoadingMessage:@"Authenticating..."];
    TwitterAccountManager *twitterAccountManager = [TwitterAccountManager shared];
    twitterAccountManager.delegate = self;
    [twitterAccountManager signInWithUserName:userNameTextField.text andPassword:passwordTextField.text];
}

- (void)signOutButtonClicked{
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [messageView showLoadingMessage:@"Signing out..."];
    TwitterAccountManager *twitterAccountManager = [TwitterAccountManager shared];
    twitterAccountManager.delegate = self;
    [twitterAccountManager signOut];
}

- (void)twitterAccountManagerDidSuccessfullySignIn{
    [messageView hide];
    [self setUpNavigationButtons];
    [self.tableView reloadData];
    [self setCreateTextAccountFooterVisiblity];
}

- (void)twitterAccountManagerDidSuccessfullySignOut{
    [messageView hide];
    userNameTextField.text = @"";
    passwordTextField.text = @"";
    [self setUpNavigationButtons];
    [self.tableView reloadData];
    [self setCreateTextAccountFooterVisiblity];
}

- (void)twitterAccountManagerDidFailWithError:(NSString *)errorMessage{
    [messageView hide];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
}

- (void)dealloc
{
    [messageView release];
    [userNameTextField release];
    [passwordTextField release];
    [super dealloc];
}

@end
