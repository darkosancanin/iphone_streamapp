#import "FontSizeSelectionController.h"
#import "Global.h"

@implementation FontSizeSelectionController

@synthesize delegate, propertyName;

- (id)initWithPropertyName:(NSString *)thePropertyName andMinSize:(int)theMinSize andMaxSize:(int)theMaxSize andCurrentValue:(int)theCurrentValue andDelegate:(id<FontSizeSelectionControllerDelegate>)theDelegate{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.delegate = theDelegate;
        self.propertyName = thePropertyName;
        currentValue = theCurrentValue;
        
        fontSizes = [[NSMutableArray alloc] init];
        int fontSize = theMinSize;
        while(fontSize <= theMaxSize){
            [fontSizes addObject:[NSNumber numberWithInt:fontSize]];
            fontSize++;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fontSizes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ALPHA_LEVEL];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    NSNumber *fontSize = [fontSizes objectAtIndex:indexPath.row];
    int fontSizeValue = [fontSize intValue];
    cell.textLabel.text = [NSString stringWithFormat:@"%ipt", fontSizeValue];
    if(fontSizeValue == currentValue){
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick.png"]];
		cell.accessoryView = accessoryView;
		[accessoryView release];
    }
    else{
        cell.accessoryView = nil;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *fontSize = [fontSizes objectAtIndex:indexPath.row];
    [self.delegate didSelectFontSizeOf:[fontSize intValue] forPropertyName:self.propertyName];
}

- (void)dealloc
{
    [fontSizes release];
    [propertyName release];
    [super dealloc];
}

@end
