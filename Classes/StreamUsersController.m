#import "StreamUsersController.h"
#import "Global.h"
#import "UserController.h"

@implementation StreamUsersController

@synthesize stream;

- (id)initWithStream:(Stream *)theStream{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.stream = theStream;
        self.title = theStream.shortName;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stream.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
		UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_arrow.png"]];
		cell.accessoryView = accessoryView;
		[accessoryView release];
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
		cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_LEVEL];
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
		cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    
    User *user = [self.stream.users objectAtIndex:indexPath.row];
    cell.textLabel.text = user.fullName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@", user.userName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    User *user = [self.stream.users objectAtIndex:indexPath.row];
    UserController *userController = [[UserController alloc] initWithAUser:user];
    [self.navigationController pushViewController:userController animated:YES];
    [userController release];
}

- (void)dealloc{
    [stream release];
    [super dealloc];
}

@end
