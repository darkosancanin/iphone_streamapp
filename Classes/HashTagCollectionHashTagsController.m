#import "HashTagCollectionHashTagsController.h"
#import "Global.h"
#import "SearchController.h"

@implementation HashTagCollectionHashTagsController

@synthesize hashTagCollection;

- (id)initWithHashTagCollection:(HashTagCollection *)theHashTagCollection{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.hashTagCollection = theHashTagCollection;
        self.title = theHashTagCollection.shortName;
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
    return self.hashTagCollection.hashTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_arrow.png"]];
		cell.accessoryView = accessoryView;
		[accessoryView release];
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
		cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_LEVEL];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"#%@", [self.hashTagCollection.hashTags objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *hashTag = [self.hashTagCollection.hashTags objectAtIndex:indexPath.row];
    SearchController *searchController = [[SearchController alloc] initWithSearchTerm:[NSString stringWithFormat:@"#%@", hashTag]];
    [self.navigationController pushViewController:searchController animated:YES];
    [searchController release];
}

- (void)dealloc{
    [hashTagCollection release];
    [super dealloc];
}

@end
